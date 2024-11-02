import 'package:flutter/material.dart';
import '../../utils/currency_formatter.dart';
import '../../domain/models/doctor.dart';

class ServiceModel {
  final String id;
  final String name;
  final Duration duration;
  final int price;
  final Color color;
  final List<Doctor> doctors;

  ServiceModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.color,
    required this.doctors,
  });

  String get formattedPrice => CurrencyFormatter.formatIQD(price);

  // Add a fromJson constructor
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: Duration(minutes: json['durationMinutes'] as int),
      price: json['price'] as int,
      color: Color(json['color'] as int),
      doctors: (json['doctors'] as List<dynamic>?)
              ?.map((d) => Doctor.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Add a toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationMinutes': duration.inMinutes,
      'price': price,
      'color': color.value,
      'doctors': doctors.map((d) => d.toJson()).toList(),
    };
  }
}

class ServiceProvider extends ChangeNotifier {
  List<Doctor> _doctors = [
    Doctor(id: '1', name: 'Dr. Sarah Ahmad', specialty: 'Dermatologist'),
    Doctor(id: '2', name: 'Dr. Ali Hassan', specialty: 'Cosmetologist'),
    Doctor(
        id: '3', name: 'Dr. Maryam Khalil', specialty: 'Aesthetic Specialist'),
  ];

  List<ServiceModel> _services = [];

  ServiceProvider() {
    _initializeServices();
  }

  void _initializeServices() {
    // Initialize services with doctors assigned
    _services = [
      ServiceModel(
        id: '1',
        name: 'Facial',
        duration: Duration(hours: 1),
        price: 75000,
        color: Colors.blue,
        doctors: [_doctors[0], _doctors[1]], // Assign multiple doctors
      ),
      ServiceModel(
        id: '2',
        name: 'Lash lift',
        duration: Duration(hours: 1),
        price: 75000,
        color: Colors.green,
        doctors: [_doctors[1]], // Assign single doctor
      ),
      ServiceModel(
        id: '3',
        name: 'Eyebrow wax',
        duration: Duration(minutes: 25),
        price: 75000,
        color: Colors.purple,
        doctors: [_doctors[2]], // Assign single doctor
      ),
      ServiceModel(
        id: '4',
        name: 'Lip wax',
        duration: Duration(minutes: 20),
        price: 75000,
        color: Colors.blue,
        doctors: [_doctors[0], _doctors[2]], // Assign multiple doctors
      ),
    ];
  }

  List<ServiceModel> get services => List.unmodifiable(_services);
  List<Doctor> get doctors => List.unmodifiable(_doctors);

  void addDoctor(Doctor doctor) {
    _doctors.add(doctor);
    notifyListeners();
  }

  void updateDoctor(Doctor updatedDoctor) {
    final index = _doctors.indexWhere((doc) => doc.id == updatedDoctor.id);
    if (index != -1) {
      _doctors[index] = updatedDoctor;
      notifyListeners();
    }
  }

  void addService(ServiceModel service) {
    _services.add(service);
    notifyListeners();
  }

  void updateService(ServiceModel updatedService) {
    final index =
        _services.indexWhere((service) => service.id == updatedService.id);
    if (index != -1) {
      _services[index] = updatedService;
      notifyListeners();
    }
  }

  void deleteServices(List<String> serviceIds) {
    _services.removeWhere((service) => serviceIds.contains(service.id));
    notifyListeners();
  }

  // Optional: Add method to get doctors by service
  List<Doctor> getDoctorsForService(String serviceId) {
    final service = _services.firstWhere(
      (service) => service.id == serviceId,
      orElse: () => ServiceModel(
        id: '',
        name: '',
        duration: Duration.zero,
        price: 0,
        color: Colors.blue,
        doctors: [],
      ),
    );
    return service.doctors;
  }

  // Optional: Add method to check if doctor is assigned to service
  bool isDoctorAssignedToService(String serviceId, String doctorId) {
    return getDoctorsForService(serviceId)
        .any((doctor) => doctor.id == doctorId);
  }
}
