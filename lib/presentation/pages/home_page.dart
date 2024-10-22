import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../blocs/appointment_card.dart';
import 'all_appointments_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20),
                  _buildWelcomeSection(),
                  SizedBox(height: 20),
                  _buildUrgentCareButton(),
                  SizedBox(height: 30),
                  _buildServicesSection(context),
                  SizedBox(height: 30),
                  _buildAppointmentSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.grey[600]),
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.notifications_outlined, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9AA2), Color(0xFFFFB7B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome!',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'Rajesh',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            'How is it going today?',
            style:
                TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentCareButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
      label: Text('Urgent Care', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFA62B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Services',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildServiceItem(
                context, Icons.medical_services_outlined, 'Services', () {
              Navigator.pushNamed(context, '/services');
            }),
            _buildServiceItem(
                context, Icons.medication_outlined, 'Medicines', () {}),
            _buildServiceItem(
                context, Icons.local_hospital_outlined, 'Ambulance', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 114, 114, 114), width: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Appointments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllAppointmentsPage()),
                );
              },
              child: Text(
                'See All',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Consumer<AppointmentProvider>(
          builder: (context, appointmentProvider, child) {
            final todayAppointments =
                appointmentProvider.getTodayAppointments();
            final displayAppointments = todayAppointments.take(2).toList();

            return Column(
              children: displayAppointments.isEmpty
                  ? [Text('No appointments for today')]
                  : displayAppointments
                      .map((appointment) => _buildAppointmentCard(appointment))
                      .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: AppointmentCard(
        name: appointment.name,
        type: appointment.type,
        doneBy: appointment.doneBy,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        total: appointment.total,
        isCompleted: appointment.isCompleted,
        colorBar: appointment.colorBar,
        additionalInfo: null,
      ),
    );
  }

  String _calculateDuration(DateTime startTime, DateTime endTime) {
    final difference = endTime.difference(startTime);
    return '${difference.inMinutes} min';
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1].split(' ')[0]);
    final isPM = time.toLowerCase().contains('pm');
    return DateTime(2024, 1, 1, isPM && hour != 12 ? hour + 12 : hour, minute);
  }
}
