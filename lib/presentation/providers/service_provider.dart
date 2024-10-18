import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String name;
  final Duration duration;
  final int price;
  final Color color;

  ServiceModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.color,
  });
}

class ServiceProvider extends ChangeNotifier {
  List<ServiceModel> _services = [
    ServiceModel(id: '1', name: 'Facial', duration: Duration(hours: 1), price: 50, color: Colors.blue),
    ServiceModel(id: '2', name: 'Lash lift', duration: Duration(hours: 1), price: 50, color: Colors.green),
    ServiceModel(id: '3', name: 'Eyebrow wax', duration: Duration(minutes: 25), price: 50, color: Colors.purple),
    ServiceModel(id: '4', name: 'Lip wax', duration: Duration(minutes: 20), price: 50, color: Colors.blue),
  ];

  List<ServiceModel> get services => _services;

  void addService(ServiceModel service) {
    _services.add(service);
    notifyListeners();
  }

  void updateService(ServiceModel updatedService) {
    final index = _services.indexWhere((service) => service.id == updatedService.id);
    if (index != -1) {
      _services[index] = updatedService;
      notifyListeners();
    }
  }

  void deleteServices(List<String> serviceIds) {
    _services.removeWhere((service) => serviceIds.contains(service.id));
    notifyListeners();
  }
}