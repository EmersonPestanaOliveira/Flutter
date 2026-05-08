# Firestore indexes - Alertas

A aba Alertas/Mapa Comunitario consulta a colecao `alertas` por viewport.
Para isso o app calcula ranges de `geohash` que cobrem a regiao visivel do
mapa e executa uma query para cada range.

Campos usados nas queries atuais:

- `geohash`: usado em `orderBy`, `startAt` e `endAt` para limitar o viewport.
- `tipo`: usado quando o filtro possui exatamente um tipo selecionado.
- `data`: usado pelos filtros de periodo, incluindo "ultimos 7 dias".

## Indices esperados

Crie os indices compostos abaixo para a colecao `alertas` no Firebase Console.
Se o projeto passar a versionar `firestore.indexes.json`, estes indices devem
ser adicionados ao arquivo.

1. Query por geohash:
   - `geohash ASC`

2. Query por geohash + tipo:
   - `tipo ASC`
   - `geohash ASC`

3. Query por geohash + data:
   - `data DESC`
   - `geohash ASC`

4. Query por geohash + tipo + data:
   - `tipo ASC`
   - `data DESC`
   - `geohash ASC`

> Observacao: a query real usa `orderBy('geohash')` combinado com filtros por
> `data`. Se o Firestore sugerir uma ordem diferente ao criar o indice pelo
> link do erro, siga a ordem exigida pela query publicada.

## Fallback

A ausencia desses indices pode gerar erro `failed-precondition` no Firestore.
Quando isso acontece, o datasource registra telemetria especifica
`missing_firestore_index` e aciona o evento `alertas_query_fallback_used`.

O fallback existe apenas como contingencia para manter a UX funcionando em
bases pequenas ou ambientes incompletos. Ele nao deve ser o caminho principal
em producao porque pode buscar documentos demais antes de filtrar por viewport.

Nao trate `alertas_query_fallback_used` como comportamento normal em producao.
Ao aparecer em telemetria, crie o indice ausente e acompanhe a queda do evento.
