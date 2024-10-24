import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../blocs/appointment_card.dart';

class AllAppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Appointments"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, child) {
          final todayAppointments = appointmentProvider.getTodayAppointments();

          return todayAppointments.isEmpty
              ? Center(child: Text('No appointments for today'))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: todayAppointments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildAppointmentCard(todayAppointments[index]),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return AppointmentCard(
      appointment: appointment,
    );
  }
}
