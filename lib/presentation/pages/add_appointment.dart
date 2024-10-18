import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_client.dart';
import '../providers/service_provider.dart';

class AddAppointment extends StatefulWidget {
  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String _reminder = '';
  String _selectedClient = '';
  List<ServiceModel> _selectedServices = [];
  TextEditingController _messageController = TextEditingController();

  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _calculateEndTime();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _calculateEndTime() {
    if (_selectedServices.isEmpty) {
      _endTime = _startTime;
    } else {
      int totalMinutes = _selectedServices.fold(
          0, (sum, service) => sum + service.duration.inMinutes);
      DateTime endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      ).add(Duration(minutes: totalMinutes));

      _endTime = TimeOfDay.fromDateTime(endDateTime);
    }
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
              if (_showErrors && _selectedClient.isEmpty)
                _buildErrorText('Client is required'),
              SizedBox(height: 24),
              _buildSectionTitle('ADD SERVICES'),
              _buildServiceSelector(),
              if (_showErrors && _selectedServices.isEmpty)
                _buildErrorText('At least one service is required'),
              SizedBox(height: 16),
              ..._selectedServices.map(_buildSelectedServiceItem).toList(),
              SizedBox(height: 24),
              _buildDateTimePicker(),
              SizedBox(height: 24),
              _buildReminderOption(),
              if (_showErrors && _reminder.isEmpty)
                _buildErrorText('Reminder is required'),
              SizedBox(height: 24),
              _buildSectionTitle('Add Extra Information'),
              _buildTextField(_messageController, Icons.message_outlined,
                  'Additional Message'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
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
            _showErrors = false;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _showErrors && _selectedClient.isEmpty
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedClient.isEmpty ? 'Select Client' : _selectedClient,
              style: TextStyle(
                color: _selectedClient.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelector() {
    return InkWell(
      onTap: () => _showServicePicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _showErrors && _selectedServices.isEmpty
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedServices.isEmpty
                  ? 'Select Service'
                  : 'Add Another Service',
              style: TextStyle(color: Colors.grey),
            ),
            Icon(Icons.add, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  void _showServicePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Consumer<ServiceProvider>(
          builder: (context, serviceProvider, child) {
            return Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Service',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: serviceProvider.services.length,
                      itemBuilder: (context, index) {
                        ServiceModel service = serviceProvider.services[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: service.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  service.name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: service.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              service.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              '${service.duration.inMinutes} min - \$${service.price}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Icon(Icons.add, color: Colors.blue),
                            onTap: () {
                              setState(() {
                                if (!_selectedServices.contains(service)) {
                                  _selectedServices.add(service);
                                  _calculateEndTime();
                                }
                              });
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectedServiceItem(ServiceModel service) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(service.name, style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${service.duration.inMinutes} min - \$${service.price}'),
            ],
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedServices.remove(service);
                _calculateEndTime(); // Recalculate end time after removing a service
              });
            },
          ),
        ],
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
        _calculateEndTime();
      });
    }

    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedStartTime != null && pickedStartTime != _startTime) {
      setState(() {
        _startTime = pickedStartTime;
        _calculateEndTime();
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
    return InkWell(
      onTap: () => _showReminderOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  _showErrors && _reminder.isEmpty ? Colors.red : Colors.grey,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reminder', style: TextStyle(color: Colors.black)),
            Row(
              children: [
                Text(_reminder.isEmpty ? 'Select Reminder' : _reminder,
                    style: TextStyle(
                        color: _reminder.isEmpty ? Colors.grey : Colors.black)),
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set Reminder',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              _buildReminderOptionTile('30 minutes before'),
              _buildReminderOptionTile('1 hour before'),
              _buildReminderOptionTile('1 day before'),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderOptionTile(String option) {
    return InkWell(
      onTap: () => _updateReminder(option),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            if (_reminder == option) Icon(Icons.check, color: Colors.blue)
          ],
        ),
      ),
    );
  }

  void _updateReminder(String newReminder) {
    setState(() {
      _reminder = newReminder;
      _showErrors = false;
    });
    Navigator.pop(context);
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(icon, color: Colors.grey),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
    );
  }

  void _saveAppointment() {
    setState(() {
      _showErrors = true;
    });

    if (_selectedClient.isNotEmpty &&
        _selectedServices.isNotEmpty &&
        _reminder.isNotEmpty) {
      // TODO: Implement API call to save the appointment
      // API call would look something like this:
      // apiService.createAppointment(
      //   client: _selectedClient,
      //   services: _selectedServices,
      //   date: _selectedDate,
      //   startTime: _startTime,
      //   endTime: _endTime,
      //   reminder: _reminder,
      //   additionalMessage: _messageController.text,
      // );

      print('Appointment details:');
      print('Client: $_selectedClient');
      print('Services: ${_selectedServices.map((s) => s.name).join(', ')}');
      print('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}');
      print(
          'Time: ${_startTime.format(context)} to ${_endTime.format(context)}');
      print('Reminder: $_reminder');
      print('Additional Message: ${_messageController.text}');
      Navigator.pop(context);
    } else {
      // Show a snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
