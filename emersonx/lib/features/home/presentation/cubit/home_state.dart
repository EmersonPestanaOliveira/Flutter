import '../../domain/entities/feature_module.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  HomeLoaded(this.modules);
  final List<FeatureModule> modules;
}

class HomeError extends HomeState {
  HomeError(this.message);
  final String message;
}