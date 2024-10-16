import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAppointment extends StatefulWidget {
  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final _formKey = GlobalKey<FormState>();
  String _client = '';
  String _service = '';
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _doesNotRepeat = true;
  String _reminder = '1 hour before';
  String _additionalInfo = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Prepare data for API request
      final appointmentData = {
        'client': _client,
        'service': _service,
        'startDateTime': DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          _startTime.hour,
          _startTime.minute,
        ).toIso8601String(),
        'endDateTime': DateTime(
          _endDate.year,
          _endDate.month,
          _endDate.day,
          _endTime.hour,
          _endTime.minute,
        ).toIso8601String(),
        'doesNotRepeat': _doesNotRepeat,
        'reminder': _reminder,
        'additionalInfo': _additionalInfo,
      };
      
      // TODO: Send appointmentData to API
      print(appointmentData); // For demonstration, replace with actual API call
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('New appointment', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text('Save', style: TextStyle(color: Colors.indigo)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(Icons.person, 'Client Name', (value) => _client = value),
              _buildInputField(Icons.label, 'Service', (value) => _service = value),
              _buildDateTimeField(),
              _buildReminderField(),
              _buildInputField(Icons.more_horiz, 'Additional Info', (value) => _additionalInfo = value, maxLines: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String label, Function(String) onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.indigo),
          labelText: label,
        ),
        maxLines: maxLines,
        onSaved: (value) => onSaved(value ?? ''),
        validator: (value) => value?.isEmpty ?? true ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDateTimeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.indigo,),
            title: Text('Start Date and Time'),
            subtitle: Text(DateFormat('MMM d, y HH:mm').format(DateTime(_startDate.year, _startDate.month, _startDate.day, _startTime.hour, _startTime.minute))),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _startDate = date);
                final time = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (time != null) {
                  setState(() => _startTime = time);
                }
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.indigo),
            title: Text('End Date and Time'),
            subtitle: Text(DateFormat('MMM d, y HH:mm').format(DateTime(_endDate.year, _endDate.month, _endDate.day, _endTime.hour, _endTime.minute))),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _endDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _endDate = date);
                final time = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                );
                if (time != null) {
                  setState(() => _endTime = time);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchField(IconData icon, String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo),
          SizedBox(width: 16),
          Text(label),
          Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.notifications, color: Colors.indigo),
          SizedBox(width: 16),
          Text('Reminder'),
          Spacer(),
          DropdownButton<String>(
            value: _reminder,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() => _reminder = newValue);
              }
            },
            items: <String>['1 hour before', '2 hours before', '1 day before', 'No reminder']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}