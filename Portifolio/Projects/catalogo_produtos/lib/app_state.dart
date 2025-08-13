import 'package:flutter/material.dart';
import 'viewmodels/product_viewmodel.dart';

class AppState extends InheritedWidget {
  final ProductViewModel productViewModel;

  const AppState({
    Key? key,
    required this.productViewModel,
    required Widget child,
  }) : super(key: key, child: child);

  static AppState of(BuildContext context) {
    final AppState? result =
        context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No AppState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) {
    // Aqui decidimos se deve rebuildar os widgets que dependem do AppState
    // Para simplificar, retornamos true sempre que a instância for diferente.
    return oldWidget.productViewModel != productViewModel;
  }
}
