import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_client.dart';

class AddAppointment extends StatefulWidget {
  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  String _reminder = '1 hour before';
  String _selectedClient = '';
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _serviceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('New appointment', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: _saveAppointment,
            child: Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('ADD CLIENT'),
              _buildClientSelector(),
              SizedBox(height: 24),
              _buildSectionTitle('ADD SERVICES'),
              _buildTextField(_serviceController, Icons.work_outline, 'Service Name'),
              SizedBox(height: 24),
              _buildDateTimePicker(),
              SizedBox(height: 24),
              _buildReminderOption(),
              SizedBox(height: 24),
              _buildSectionTitle('ADD ANOTHER MESSAGE'),
              _buildTextField(_messageController, Icons.message_outlined, 'Additional Message'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildClientSelector() {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddClientPage()),
        );
        if (result != null) {
          setState(() {
            _selectedClient = result;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedClient.isEmpty ? 'Select Client' : _selectedClient,
              style: TextStyle(color: _selectedClient.isEmpty ? Colors.grey : Colors.black),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: () => _selectDateTime(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.grey),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                '${DateFormat('EEE, MMM d, y').format(_selectedDate)} ${_startTime.format(context)} to ${_endTime.format(context)}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }

    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedStartTime != null && pickedStartTime != _startTime) {
      setState(() {
        _startTime = pickedStartTime;
        _endTime = pickedStartTime.replacing(hour: pickedStartTime.hour + 1);
      });
    }

    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (pickedEndTime != null && pickedEndTime != _endTime) {
      setState(() {
        _endTime = pickedEndTime;
      });
    }
  }

  Widget _buildReminderOption() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Reminder', style: TextStyle(color: Colors.black)),
          InkWell(
            onTap: _showReminderOptions,
            child: Row(
              children: [
                Text(_reminder, style: TextStyle(color: Colors.grey)),
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReminderOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: ListView(
            children: [
              ListTile(
                title: Text('30 minutes before'),
                onTap: () => _updateReminder('30 minutes before'),
              ),
              ListTile(
                title: Text('1 hour before'),
                onTap: () => _updateReminder('1 hour before'),
              ),
              ListTile(
                title: Text('1 day before'),
                onTap: () => _updateReminder('1 day before'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateReminder(String newReminder) {
    setState(() {
      _reminder = newReminder;
    });
    Navigator.pop(context);
  }

  void _saveAppointment() {
    // TODO: Implement save functionality
    print('Appointment details:');
    print('Client: $_selectedClient');
    print('Service: ${_serviceController.text}');
    print('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}');
    print('Time: ${_startTime.format(context)} to ${_endTime.format(context)}');
    print('Reminder: $_reminder');
    print('Additional Message: ${_messageController.text}');
    Navigator.pop(context);
  }
}