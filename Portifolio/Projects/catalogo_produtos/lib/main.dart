import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/product_model.dart';
import 'locator.dart';
import 'app_state.dart';
import 'viewmodels/product_viewmodel.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Hive
  await Hive.initFlutter();
  // Registra o adaptador do ProductModel
  Hive.registerAdapter(ProductModelAdapter());

  // Configura get_it
  setupLocator();

  // Carrega a ViewModel e faz load inicial dos produtos
  final productViewModel = getIt<ProductViewModel>();
  await productViewModel.loadProducts();

  runApp(MyApp(productViewModel: productViewModel));
}

class MyApp extends StatefulWidget {
  final ProductViewModel productViewModel;
  const MyApp({Key? key, required this.productViewModel}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Para este exemplo, recriamos o AppState quando houver mudança
  // Caso queira algo mais refinado, crie métodos específicos para
  // rebuildar apenas as partes que mudam.
  void rebuildApp() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      productViewModel: widget.productViewModel,
      child: MaterialApp(
        title: 'Catálogo de Produtos',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeView(onStateChanged: rebuildApp),
      ),
    );
  }
}
