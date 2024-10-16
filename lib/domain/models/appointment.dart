class Appointment {
  final String id;
  final String patientId;
  final String serviceId;
  final DateTime dateTime;
  final List<String> addOns;

  Appointment({required this.id, required this.patientId, required this.serviceId, required this.dateTime, this.addOns = const []});
}