# Reavaliação do Projeto — Case Mapa Comunitário (Gabriel)

Data: 2026-05-07

Esta nota cruza, ponto a ponto, o desafio descrito em
`gabriel-case-tecnico-engenharia-sr-mobile.pdf` com o estado atual do
repositório `gabriel_clone`. O foco é entrar na conversa técnica com clareza
sobre o que está pronto, o que é decisão consciente e o que ainda falta para
não tomar susto na lousa branca.

## Veredito rápido

A base atende todos os quatro eixos do case (offline-first, performance, estado
e observabilidade) com uma implementação real, testada e instrumentada — não
apenas slides. A maturidade do código é alta para uma vaga sênior: pipeline de
ocorrências offline com idempotência por `clientId`, outbox SQLite com backoff
+ jitter e dead-letter, sync em background via WorkManager + recuperação online
desacoplada de UI, viewport por GeoHash multi-range com fallback observável,
clustering local com policy explícita e cache de `BitmapDescriptor`. O que falta
são refinos pontuais e talking points afiados, não fundações.

## Mapa requisito → implementação

### 1. Estratégia offline-first para criar relatos

| Requisito do PDF | Implementação |
|---|---|
| Criar relato totalmente offline | `OcorrenciaRepositoryImpl.create` gera `clientId` UUID, persiste anexos no diretório de documentos via `EncryptedAttachmentStorage`, enfileira no SQLite (`pending_ocorrencias`) com `status=queued` e retorna `Right(clientId)` antes de tocar a rede. UI nunca espera resposta do servidor. |
| Armazenamento seguro no dispositivo | Outbox em `lib/core/database/app_database.dart` (SQLite via `sqlite3_flutter_libs`); payload JSON criptografado com AES-GCM (`AesGcmLocalPayloadCrypto`) usando chave de 256 bits gerada e mantida em `flutter_secure_storage`; anexos via `EncryptedAttachmentStorage`. |
| Lidar com falhas no envio | `OcorrenciaSyncWorker` classifica erro recuperável vs. permanente (`isRecoverableSyncError`), aplica `markFailed` com backoff exponencial + jitter (`PendingOcorrenciasDao._backoffFor`), promove para `deadLetter` após 5 tentativas e oferece retry manual via `RetryFailedOcorrenciaUseCase` (`resetToQueued`). Itens travados em `syncing` por mais de 10 min são reabertos por `resetStaleSyncing`. |
| Disparar sync de novo | Três gatilhos coexistem: fire-and-forget logo após criar quando online (`_trySyncOne`); WorkManager periódico de 15 min com `NetworkType.connected` (`configureBackgroundOcorrenciaSync` no `main.dart`); `OcorrenciaSyncOrchestrator` escutando `NetworkConnectionMonitor` para acionar sync ao transitar offline→online com debounce de 2s, fora do ciclo de vida da UI. |

Pontos defensáveis na entrevista:
- Idempotência: o `clientId` UUID v4 é o ID do documento Firestore, então retry
  jamais cria duplicata. É a peça mais barata e mais robusta do desenho.
- Limpeza segura: anexos só são apagados depois do `markSynced` confirmado,
  evitando perder mídia se o app for morto entre upload e ack.
- Sem PII em log: `_safeId` trunca o `clientId` a 8 chars e `Telemetry`
  tem blocklist (`email`, `name`, `phone`, `address`, `content`, `text`).

### 2. Performance de renderização e UX do mapa

| Requisito | Implementação |
|---|---|
| Milhares de pins fluidos | Viewport-based loading: `HomeCubit.onCameraIdle` com debounce de 300 ms aciona `GetAlertasInBoundsUseCase`; o repositório consulta Firestore com **GeoHash multi-range** (`AlertaRemoteDatasourceImpl.getAlertasInBounds`), executando ranges em paralelo e deduplicando. Filtros de `tipo`/`data` são aplicados no Firestore quando o índice composto existe. |
| Cluster | `AlertaClusterService.build` usa grid local (`GeoUtils.clusterCell`) com `ClusterPolicy` configurável (mín. 501 pins para ativar, `maxZoomForClustering=15.5`, alta densidade ≥ 8). Retorna `AlertaClusterResult` com `enabled`, `reason` e `elapsedMs` para telemetria. |
| Cache de ícones | `PinCache` é singleton estático com chaves `pin_${tipo.name}` e `cluster_${bucket}` (buckets 1/10/50/100/500). `resolveAlertPin` loga `map.icon_cache_hit` com sampling de 1:50 e `map.icon_cache_miss` integral. Cache não some entre rebuilds do `HomeCubit`. |
| Filtrar pins (ex.: últimos 7 dias) | `AlertaFilter` (tipos + dateFrom + dateTo) é parte do `HomeState`; `HomeCubit.updateFilter` invalida cache e força re-fetch usando o viewport corrente. Filtragem dupla: Firestore (quando dá pra empurrar) + memória (defensivo, com benchmark documentado em `docs/BENCHMARK_MAP.md`). |
| Limite numérico | Benchmark: filtro local p95 ≈ 33 ms para 10k pins, sobe para ≈ 146 ms em 50k. Esse é o gatilho explícito para depender exclusivamente do GeoHash do servidor; documentado em `docs/ARCHITECTURE_MAPA_COMUNITARIO.md` (seção "Estratégia de Escala do Viewport"). |

Pontos defensáveis:
- O mapa nunca pede "todos os pins". O `HomeCubit` só consulta o que cabe no
  viewport atual + zoom + filtro, com cache contra re-fetch quando bounds/zoom/
  filtro não mudaram (`_boundsEqual` com epsilon e tolerância de zoom 0.5).
- `GoogleMap.onCameraIdle` (não `onCameraMove`) com debounce previne
  flood durante gestos. O `_viewportQuerySeq` descarta respostas obsoletas.
- Quando o índice do Firestore some, o app não quebra: cai para `_fallbackInBounds`
  e emite `map.viewport_query_fallback` com `reason=missing_firestore_index` —
  ou seja, o produto continua funcionando enquanto a infra é corrigida.

### 3. Arquitetura e gerenciamento de estado

| Requisito | Implementação |
|---|---|
| Padrão para estado complexo | Cubit (flutter_bloc) com Clean Architecture estrita. `HomeCubit` mantém pins remotos, fila local pendente, filtro, viewport, seleção, indicadores de carregamento e estado de retry. `OcorrenciaFormCubit` controla o formulário e fala com o `CreateOcorrenciaUseCase`. |
| Lógica modular e testável | Camadas `domain → data → presentation` separadas por feature. `domain` define `UseCase`/`Repository`/entidades; `data` implementa via Firestore/SQLite/Storage; `presentation` consome só os use cases. Tipo `AppResult<T> = Either<Failure, T>` (dartz) propaga erro tipado sem exceptions vazando. |
| DI | `lib/core/di/injection_container.dart` com GetIt. Tudo registrado como singleton (deps caras) ou factory (Cubits e use cases). DI compartilhada com isolate de background do WorkManager via `setupLocator()` no `ocorrenciaSyncCallbackDispatcher`. |
| Fila offline pendente como cidadão de primeira | `HomeCubit._watchLocalPendingAlertas` mescla itens da `pending_ocorrencias` com pins remotos (`AlertaPinMergeService`), pintando-os com tints diferentes (`queued`/`syncing`/`synced`/`failed`/`deadLetter`) e expondo retry direto pelo mapa. Bridging suaviza a transição offline→sincronizado por 20 s para a UX não "piscar". |

Pontos defensáveis:
- A escolha por Cubit em vez de Bloc com eventos é consciente: o estado
  é principalmente derivado (filtro/zoom/bounds/lista pendente), com poucas
  ações explícitas; eventos seriam ruído.
- Riverpod foi descartado por consistência com o resto do app, não por mérito.
- O `AlertaRepository` é a única peça que conversa com Firestore para alertas;
  trocar GeoHash por S2 ou tiles vetoriais é mudança contida nessa classe.

### 4. Testabilidade e observabilidade

| Requisito | Implementação |
|---|---|
| Testar partes móveis | Testes unitários cobrem: outbox DAO (status, backoff, dead-letter, stale syncing), sync worker (sucesso, falha recuperável, falha permanente, dead-letter, cleanup), orchestrator (debounce de recuperação, no-op em flapping, idempotência durante sync), filtros do `HomeCubit`, cluster service, geo-utils, formulário (validação, criação, fallback offline) e benchmark de viewport. 23 arquivos de teste, ~2100 linhas. |
| Saúde em produção | `Telemetry` encapsula `FirebaseCrashlytics` (logs e `recordError`) + `FirebasePerformance` (`trace`). API mockável (`FakeTelemetry` nos testes). Sanitização automática de PII na chave dos params. |
| Métricas | Eventos padronizados em `TelemetryEvents`: `map.initial_load`, `map.viewport_loaded`, `map.viewport_query_failed`, `map.viewport_query_fallback`, `map.icon_cache_hit/miss`, `sync.started/finished/item_*`, `sync.dead_letter`, `sync.background_started/finished`, `sync.network_recovered_trigger`, `ocorrencia.created_offline`, `offline.queue_snapshot` (avg/max age, retryCount, deadLetter). |
| Alertas sugeridos | Documentados na arquitetura: taxa de sync < 95 %/h, p95 time-to-sync > 30 min, profundidade da outbox p95 > 10/usuário, crash-free users < 99,5 %. |

## Gaps que valem mexer antes da entrevista

Nenhum bloqueia a apresentação, mas vale antecipar antes de levar pancada:

1. **Inicialização do `NetworkConnectionMonitor` é `InternetAddress.lookup('google.com')`.**
   Funciona, mas se o entrevistador perguntar sobre dependência de DNS externo
   ou ambiente corporativo, é honesto reconhecer que `connectivity_plus` (já no
   pubspec) cobre o caso de "rede caiu" e o lookup é apenas o reforço para
   detectar internet real (captive portals, DNS preso). Talking point, não fix.
2. **Crypto da outbox usa `InMemoryLocalCryptoKeyStore` por padrão no construtor
   do `OcorrenciaLocalDatasourceImpl`.** Em produção a DI injeta o
   `AesGcmLocalPayloadCrypto` com `SecureStorageLocalCryptoKeyStore`, mas o
   default seguro deveria estar no construtor para não cair num caminho fraco
   se alguém esquecer da DI. Pequeno ajuste defensivo: tornar o `crypto`
   obrigatório (não-nullable, sem fallback in-memory) e deixar o uso sem
   cripto explícito apenas em `@visibleForTesting`.
3. **`SecureOccurrenceStore` existe e duplica a lógica do
   `OcorrenciaLocalDatasourceImpl`.** Ambos criptografam payload na enfileiragem
   e descriptografam na leitura, mas o app usa o datasource. Vale ou consolidar
   (datasource passa a delegar para `SecureOccurrenceStore`) ou apagar a fachada
   não usada para evitar pergunta "por que tem dois?".
4. **iOS background.** `configureBackgroundOcorrenciaSync` chama `Workmanager().registerPeriodicTask`,
   que no iOS depende de `BGTaskScheduler` configurado no `Info.plist` e
   `AppDelegate` Swift. O comentário no código já diz "best-effort", mas o app
   precisa do registro nativo para o `15 min` realmente disparar. Bom levantar
   isso por sinceridade (e mostrar que conhece a limitação) — não tentar
   esconder na entrevista.
5. **Retry de attachments.** O `OcorrenciaSyncWorker` só refaz `createOcorrencia`,
   que internamente faz upload novamente para o Storage. Vale falar sobre
   resumable upload (`UploadTask.resume` do Firebase Storage) como evolução
   para arquivos grandes em rede ruim.
6. **Conflict resolution.** O case fala em colaborativo, não em edição compartilhada,
   então last-write-wins resolve. Bom citar para preempção de pergunta
   ("não temos edição concorrente; em cenário com edição, eu adicionaria
   `updatedAt` server-side + check-and-set").

## Como me preparei para perguntas que devem cair

- "Por que SQLite e não Drift/Isar/Hive?" — SQLite puro com SQL explícito
  remove camada de codegen, deixa o esquema visível e simplifica o teste com
  `sqlite3.openInMemory`. Para esse volume de outbox, ganho de Drift seria
  zero; perda em transparência seria real.
- "Por que GeoHash e não tile server?" — GeoHash entrega filtragem barata por
  range com uma única coluna indexada e responde em ms para alguns milhares
  de docs por viewport. Tile server custa stack nova (servidor de mapas,
  build pipeline, cache CDN) e só ganha quando viramos "mostrar densidade",
  não "mostrar pin clicável".
- "Por que clustering client-side e não `google_maps_cluster_manager`?" —
  Conflitos conhecidos com `google_maps_flutter` em algumas versões + falta
  de telemetria sobre decisão de cluster. Implementação própria é simples
  (grid por célula GeoHash), testável e instrumentada (`map.viewport_loaded`
  carrega `clusterCount`, `individualPinCount`, `clusterDecisionReason`).
- "Como você testa renderização do mapa em si?" — Não testo. Mapa é integration
  test de plataforma e custo alto vs. retorno baixo. Eu testo o `HomeCubit`
  (estado), o `AlertaClusterService` (decisão), o `PinCache` (idempotência) e
  o `GetAlertasInBoundsUseCase` (filtragem). O resto é golden ou e2e em
  Firebase Test Lab quando vira regression real.

## Fluxo offline-first em uma frase

`UI → Cubit → UseCase → Repository → SQLite outbox (queued, criptografado) →
[network recover OU WorkManager periódico OU fire-and-forget] → SyncWorker →
Firestore + Storage com clientId como ID → markSynced + cleanup`. Tudo
idempotente, observável e tolerante a app kill em qualquer ponto.
