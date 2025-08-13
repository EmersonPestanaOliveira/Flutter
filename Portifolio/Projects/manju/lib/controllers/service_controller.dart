import 'package:flutter/foundation.dart';
import 'package:manju/data/repositories/service_repository.dart';
import 'package:manju/models/service_model.dart';

class ServiceController extends ChangeNotifier {
  final ServiceRepository serviceRepository;

  ServiceController(this.serviceRepository);

  List<ServiceModel> _services = [];
  List<ServiceModel> get services => _services;

  Future<void> loadServices() async {
    _services = await serviceRepository.getAllServices();
    notifyListeners();
  }

  /// Carregar serviços de um dia específico
  Future<void> loadServicesByDate(DateTime date) async {
    _services = await serviceRepository.getServicesByDate(date);
    notifyListeners();
  }

  Future<void> addService(ServiceModel service) async {
    await serviceRepository.insertService(service);
    notifyListeners();
  }

  Future<void> deleteService(int id) async {
    await serviceRepository.deleteService(id);
    notifyListeners();
  }
}
