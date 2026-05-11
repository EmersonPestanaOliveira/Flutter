# Firestore indexes - Alertas

A aba Alertas/Mapa Comunitario consulta a colecao `alertas` por viewport.
Para isso o app calcula ranges de `geohash` que cobrem a regiao visivel do
mapa e executa uma query para cada range.

Campos usados nas queries atuais:

- `geohash`: usado em `orderBy`, `startAt` e `endAt` para limitar o viewport.
- `tipo`: usado quando o filtro possui exatamente um tipo selecionado.
- `data`: aplicado no app depois do corte espacial por `geohash`.

## Indices esperados

Crie os indices compostos abaixo para a colecao `alertas` no Firebase Console.
Se o projeto passar a versionar `firestore.indexes.json`, estes indices devem
ser adicionados ao arquivo.

1. Query por geohash:
   - `geohash ASC`

2. Query por geohash + tipo:
   - `tipo ASC`
   - `geohash ASC`

O filtro de data nao entra na query do Firestore porque o viewport depende de
cursor/range em `geohash`. Aplicar `data` no cliente, depois do corte espacial,
evita uma query fragil com multiplos campos de range/ordenacao e mantem o erro
de indice restrito ao caminho critico do mapa.

## Falha de indice

A ausencia desses indices pode gerar erro `failed-precondition` no Firestore.
Quando isso acontece, o datasource registra telemetria especifica
`missing_firestore_index` e propaga a falha como `map.viewport_query_failed`.

O caminho por GeoHash e obrigatorio para viewport em bases grandes. Nao ha
fallback in-memory para buscar a colecao limitada e filtrar no cliente, porque
isso mascara indice ausente e nao escala. Ao aparecer `missing_firestore_index`
em telemetria, crie o indice ausente e acompanhe a queda do evento.
