import 'package:flutter/foundation.dart';

class Appointment {
  final String id;
  final String serviceName;
  final DateTime dateTime;

  Appointment({required this.id, required this.serviceName, required this.dateTime});
}

class AppointmentsProvider with ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void removeAppointment(String id) {
    _appointments.removeWhere((appointment) => appointment.id == id);
    notifyListeners();
  }

  // More methods as needed...
}