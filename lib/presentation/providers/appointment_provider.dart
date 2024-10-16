import 'package:flutter/foundation.dart';
import '../../domain/models/appointment.dart';

class AppointmentProvider with ChangeNotifier {
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

  // Add more methods as needed
}