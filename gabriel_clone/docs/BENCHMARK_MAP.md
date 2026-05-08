# Benchmark - Mapa Comunitario

Ambiente: `flutter test test/features/home/domain/usecases/map_viewport_benchmark_test.dart`
em Windows, Flutter 3.41.1/Dart 3.11.0, modo test/debug. Cada linha roda 9
amostras e reporta p50/p95 em microssegundos.

| Pins sinteticos | Filtrados | `_filterInBounds` p50 | `_filterInBounds` p95 | `AlertaClusterService.build` p50 | `AlertaClusterService.build` p95 |
|---:|---:|---:|---:|---:|---:|
| 1.000 | 375 | 5,1 ms | 13,9 ms | 1,9 ms | 12,3 ms |
| 5.000 | 1.875 | 19,2 ms | 22,2 ms | 2,1 ms | 5,5 ms |
| 10.000 | 3.750 | 28,3 ms | 32,7 ms | 2,7 ms | 5,7 ms |
| 50.000 | 18.750 | 145,7 ms | 146,5 ms | 13,8 ms | 16,4 ms |

Leitura: a filtragem local fica confortavel ate perto de 10k pins carregados no
cliente. Em 50k, o p95 da filtragem passa de 140 ms antes mesmo do custo de
renderizacao do Google Maps; esse e o ponto pratico para mover o corte espacial
para o backend com GeoHash/indices. O clustering local permanece barato no
cenario medido, mas depende de receber uma lista ja limitada pelo viewport.
