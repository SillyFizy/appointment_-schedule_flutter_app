class Patient {
  final String id;
  final String name;
  final String phoneNumber;
  final List<String> appointmentHistory;

  Patient({required this.id, required this.name, required this.phoneNumber, this.appointmentHistory = const []});
}