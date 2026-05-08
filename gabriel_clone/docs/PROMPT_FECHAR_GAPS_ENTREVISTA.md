# Prompt — Fechar gaps defensáveis do case Gabriel

> Cole este prompt em uma nova sessão do Claude Code (ou outro agente) com o repositório `gabriel_clone` aberto. Ele assume Flutter + Cubit + Clean Architecture + SQLite (Drift) + Firebase, padrão já usado no projeto.

---

## Contexto

Sou engenheiro mobile sênior preparando o case técnico da Gabriel ("Mapa Comunitário"). A implementação já está em pé na tela de alertas (`lib/features/home`) e em ocorrências (`lib/features/ocorrencias`). A arquitetura está documentada em `docs/ARCHITECTURE_MAPA_COMUNITARIO.md`.

Restam 3 gaps que o entrevistador pode cutucar. Quero fechar **cada um** com (a) ajuste/refino de código quando fizer sentido e (b) um parágrafo curto de "talking point" em português que eu possa usar na lousa branca da entrevista. **Não quebre testes existentes**. Siga os padrões já presentes no projeto (Cubit, AppResult/Either, Telemetry, UseCases).

Antes de codar qualquer coisa, leia:
- `docs/ARCHITECTURE_MAPA_COMUNITARIO.md`
- `lib/features/home/domain/usecases/get_alertas_in_bounds_usecase.dart`
- `lib/features/home/data/repositories/alerta_repository_impl.dart`
- `lib/features/home/presentation/cubit/home_cubit.dart`
- `lib/features/home/presentation/widgets/home_map.dart`
- `lib/features/home/presentation/widgets/pin_cache.dart`
- `lib/features/home/presentation/widgets/alert_pin_factory.dart`
- `lib/core/sync/ocorrencia_sync_worker.dart`
- `lib/features/ocorrencias/data/repositories/ocorrencia_repository_impl.dart`
- `lib/core/observability/telemetry.dart`
- `pubspec.yaml` (para ver o que já está disponível)

Rode `flutter test` ao final para garantir que nada quebrou.

---

## Gap 1 — Filtro de viewport ainda em memória

**Sintoma.** `GetAlertasInBoundsUseCase._filterInBounds` filtra por bounds + tipo + data direto na lista vinda do repositório. Funciona, mas não escala. O doc menciona geohash/S2/tiles como evolução, mas sem benchmark concreto.

**O que quero:**
1. **Numerar o limite atual.** Adicionar um teste/benchmark simples (pode ser em `test/` com `setUp` gerando N alertas sintéticos via `home_fixtures`) que meça o tempo de `_filterInBounds` e `AlertaClusterService.build` para 1k, 5k, 10k, 50k pins. Reportar p50/p95 em `debugPrint` ou em um arquivo `docs/BENCHMARK_MAP.md`. Quero poder dizer "passa de Y ms acima de X mil pins, é onde o servidor precisa entrar".
2. **Documentar o caminho de migração** em `docs/ARCHITECTURE_MAPA_COMUNITARIO.md` (seção nova "Estratégia de Escala do Viewport") com:
   - Quando trocar para geohash no Firestore (limite numérico baseado no benchmark acima).
   - Quando trocar geohash por S2 cells ou tiles vetoriais pré-renderizados.
   - Como o `GetAlertasInBoundsUseCase` evoluiria sem quebrar a API pública (manter assinatura, mudar só a impl no repository).
3. **Talking point** de 4-6 linhas, em pt-BR, que eu possa falar na lousa: "hoje temos X, escala até Y, depois disso a gente migra para Z porque...".

**Não faça:** não introduzir geoflutterfire/S2 agora. Só medir, documentar e deixar a porta aberta.

---

## Gap 2 — Sync em background sem WorkManager/BGTaskScheduler

**Sintoma.** O `OcorrenciaRepositoryImpl.create` faz `unawaited(_trySyncOne(...))` quando online. O `OcorrenciaSyncWorker.syncPendingOcorrencias()` existe, mas não tem gatilho periódico de SO. O doc fala em WorkManager mas não está plugado.

**O que quero:**
1. **Avaliar `workmanager` (pub.dev)** já no `pubspec.yaml`. Se não estiver, adicionar e configurar:
   - Android: registrar uma task periódica (mínimo 15min) com `Constraints(networkType: NetworkType.connected)` que chama `OcorrenciaSyncWorker.syncPendingOcorrencias()`.
   - iOS: orientar (em comentário no código + doc) sobre `BGTaskScheduler` via `workmanager` iOS bindings, com a observação de que iOS é best-effort.
   - O entrypoint do isolate de background precisa inicializar Firebase, Drift e o Telemetry (mesma DI usada no app, ou uma versão enxuta). Mostrar isso no `main.dart` ou em um arquivo dedicado tipo `lib/core/sync/background_sync_entrypoint.dart`.
2. **Gatilho de "voltou online"** — usar o `NetworkConnectionMonitor` que já existe (`lib/core/network/network_connection_monitor.dart`) para disparar `syncPendingOcorrencias()` ao transitar `offline → online`. Esse gatilho deve viver fora do `Cubit` (não acoplar à UI). Sugestão: um `OcorrenciaSyncOrchestrator` em `lib/core/sync/`.
3. **Telemetria nova:** `sync.background_started`, `sync.background_finished`, `sync.network_recovered_trigger`. Sem PII.
4. **Testes:** unit test do orchestrator (mockando `NetworkConnectionMonitor` e `OcorrenciaSyncWorker`) cobrindo: dispara ao recuperar rede, não dispara em flapping rápido (debounce ≥ 2s), não dispara se já está sincronizando.
5. **Talking point** de 5-7 linhas explicando o trade-off: por que WorkManager + recovery online em vez de só foreground; por que iOS é limitado; como dimensionar o intervalo (bateria vs frescor de dados).

**Não faça:** não implementar push/FCM como gatilho de sync. Fora do escopo.

---

## Gap 3 — Cache de `BitmapDescriptor` (PinCache)

**Sintoma.** `PinCache` existe (`lib/features/home/presentation/widgets/pin_cache.dart`) e é populado em `home_map.dart` via `PinCache.storeAlertPins`. Telemetry tem `map.icon_cache_hit/miss` previstos. **Quero confirmar que o cache realmente está sendo lido no caminho de renderização e instrumentar a observabilidade.**

**O que quero:**
1. **Auditar o caminho de leitura.** Onde `home_marker_factory.dart` / `alert_pin_factory.dart` resolvem o `BitmapDescriptor` para um `Marker`, garantir que:
   - Primeiro consultam `PinCache` (hit → usa).
   - Em miss, criam o ícone, armazenam no cache e logam `map.icon_cache_miss`.
   - Em hit, logam `map.icon_cache_hit` (com sampling se necessário, p.ex. 1 em cada 50 hits, para não inundar).
2. **Garantir que o cache não recria** quando `HomeCubit` emite novos `state`s (alterações de filtro/zoom). O cache deve ser por sessão da tela, não por rebuild. Se hoje recria, mover para um lugar com lifecycle correto (ex.: `initState` da `home_map.dart` ou um singleton `PinCache` puramente estático).
3. **Teste novo** (ou complemento ao `pin_cache_test.dart`) que verifica: dadas N chamadas para o mesmo `AlertaTipo`, só há 1 criação real do `BitmapDescriptor` e N-1 hits.
4. **Talking point** de 4-5 linhas: "criar `BitmapDescriptor` é caro porque vai pra plataforma nativa, então cacheamos por `AlertaTipo` (≤8 ícones); o resto do clustering só recombina pins, nunca recria asset".

**Não faça:** não trocar `google_maps_flutter` por outra lib. Não introduzir tiles vetoriais.

---

## Formato da entrega

Para **cada gap**, me devolva nesta ordem:
1. Lista de arquivos alterados/criados (caminhos relativos).
2. Diff resumido das mudanças principais (não precisa colar 100% do diff, só o que importa).
3. Comandos rodados para validar (`flutter test`, `flutter analyze`).
4. **Talking point** em pt-BR, pronto pra eu falar na entrevista, em texto corrido (sem bullets).

No final, atualize a seção "Estado Atual De Implementacao" do `docs/ARCHITECTURE_MAPA_COMUNITARIO.md` refletindo o que foi feito.

## Critérios de aceite

- `flutter test` passa.
- `flutter analyze` sem novos warnings.
- Padrão Cubit + UseCases + Telemetry preservado.
- Nenhum dado sensível em logs (manter o padrão `_safeId` do `OcorrenciaSyncWorker`).
- Talking points respondem o "por quê", não só o "o quê".
