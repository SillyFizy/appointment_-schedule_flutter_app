import 'package:flutter/material.dart';
import '../providers/appointment_provider.dart';
import '../../utils/currency_formatter.dart';

class AppointmentDetailsView extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsView({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Appointment Details',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBar(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClientInfo(),
                  SizedBox(height: 24),
                  _buildServicesSection(),
                  SizedBox(height: 24),
                  _buildReminderSection(),
                  if (appointment.additionalMessage != null) ...[
                    SizedBox(height: 24),
                    _buildAdditionalInfo(),
                  ],
                  SizedBox(height: 24),
                  _buildActionsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      color: appointment.colorBar.withOpacity(0.1),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appointment.isCompleted ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointment.isCompleted ? 'Completed' : 'Pending',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          Text(
            CurrencyFormatter.formatIQD(
                int.parse(appointment.total.replaceAll('IQD', '').trim())),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Client Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.person_outline, 'Name', appointment.name),
            SizedBox(height: 12),
            _buildInfoRow(
                Icons.phone_outlined, 'Phone', appointment.phoneNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            ...appointment.services.map((service) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildServiceCard(service),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceAppointment service) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          _buildInfoRow(Icons.schedule, 'Time',
              '${service.startTime} - ${service.endTime}'),
          SizedBox(height: 4),
          _buildInfoRow(Icons.person_outline, 'Staff', service.doneBy),
          SizedBox(height: 4),
          _buildInfoRow(Icons.attach_money, 'Price',
              CurrencyFormatter.formatIQD(service.price)),
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: _buildInfoRow(
            Icons.notifications_outlined, 'Reminder', appointment.reminder),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              appointment.additionalMessage!,
              style: TextStyle(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.message_outlined),
            label: Text('Message'),
            onPressed: () {
              // TODO: Implement message functionality
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.phone_outlined),
            label: Text('Call'),
            onPressed: () {
              // TODO: Implement call functionality
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
