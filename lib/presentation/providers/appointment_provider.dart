import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String id;
  final String name;
  final String type;
  final String doneBy;
  final String startTime;
  final String endTime;
  final String total;
  final bool isCompleted;
  final Color colorBar;
  final DateTime lastUpdated;

  Appointment({
    required this.id,
    required this.name,
    required this.type,
    required this.doneBy,
    required this.startTime,
    required this.endTime,
    required this.total,
    required this.isCompleted,
    required this.colorBar,
    required this.lastUpdated,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      doneBy: json['doneBy'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      total: json['total'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      colorBar: json['colorBar'] is Color ? json['colorBar'] : Colors.blue,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'doneBy': doneBy,
      'startTime': startTime,
      'endTime': endTime,
      'total': total,
      'isCompleted': isCompleted,
      'colorBar': colorBar.value,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class AppointmentProvider with ChangeNotifier {
  List<Map<String, dynamic>> _appointments = [];
  DateTime? _lastSyncTime;
  bool _isSyncing = false;

  List<Map<String, dynamic>> get appointments => _appointments;
  bool get isSyncing => _isSyncing;

  // Constructor to initialize data
  AppointmentProvider() {
    _loadInitialData();
  }

  // Load initial dummy data
  void _loadInitialData() {
    _appointments = _getDummyData();
    notifyListeners();
  }

  // Separate method for dummy data
  List<Map<String, dynamic>> _getDummyData() {
    return [
      {
        'date': '2024-10-22', // Today
        'appointments': [
          {
            'id': '1',
            'name': 'Sarah Johnson',
            'type': 'Full Set Manicure',
            'doneBy': 'Emma White',
            'startTime': '9:00 AM',
            'endTime': '10:30 AM',
            'total': 'IQD75',
            'isCompleted': false,
            'colorBar': Colors.blue,
            'lastUpdated': DateTime.now().toIso8601String(),
          },
          {
            'id': '2',
            'name': 'Michael Chen',
            'type': 'Haircut & Styling',
            'doneBy': 'James Wilson',
            'startTime': '11:00 AM',
            'endTime': '12:00 PM',
            'total': 'IQD45',
            'isCompleted': false,
            'colorBar': Colors.green,
            'lastUpdated': DateTime.now().toIso8601String(),
          },
        ],
      },
      {
        'date': '2024-10-23', // Tomorrow
        'appointments': [
          {
            'id': '4',
            'name': 'David Wilson',
            'type': 'Beard Trim',
            'doneBy': 'James Wilson',
            'startTime': '10:00 AM',
            'endTime': '10:30 AM',
            'total': 'IQD25',
            'isCompleted': false,
            'colorBar': Colors.orange,
            'lastUpdated': DateTime.now().toIso8601String(),
          },
          {
            'id': '3',
            'name': 'Emily Davis',
            'type': 'Spa Package',
            'doneBy': 'Sophie Taylor',
            'startTime': '2:00 PM',
            'endTime': '4:00 PM',
            'total': 'IQD150',
            'isCompleted': false,
            'colorBar': Colors.purple,
            'lastUpdated': DateTime.now().toIso8601String(),
          },
          {
            'id': '5',
            'name': 'Lisa Anderson',
            'type': 'Hair Coloring',
            'doneBy': 'Emma White',
            'startTime': '11:00 AM',
            'endTime': '1:00 PM',
            'total': 'IQD120',
            'isCompleted': false,
            'colorBar': Colors.pink,
            'lastUpdated': DateTime.now().toIso8601String(),
          },
        ],
      },
      {
        'date': '2024-10-25',
        'appointments': [
          {
            'id': '7',
            'name': 'Jennifer Lee',
            'type': 'Facial Treatment',
            'doneBy': 'Sophie Taylor',
            'startTime': '2:00 PM',
            'endTime': '3:30 PM',
            'total': 'IQD85',
            'isCompleted': false,
            'colorBar': Colors.indigo,
            'lastUpdated': DateTime.now().toIso8601String(),
          },
          {
            'id': '6',
            'name': 'Robert Brown',
            'type': 'Full Body Massage',
            'doneBy': 'Sophie Taylor',
            'startTime': '9:30 AM',
            'endTime': '11:00 AM',
            'total': 'IQD90',
            'isCompleted': false,
            'colorBar': Colors.teal,
            'lastUpdated': DateTime.now().toIso8601String(),
          },
          {
            'id': '8',
            'name': 'William Taylor',
            'type': 'Hair Styling',
            'doneBy': 'James Wilson',
            'startTime': '4:00 PM',
            'endTime': '5:00 PM',
            'total': 'IQD55',
            'isCompleted': false,
            'colorBar': Colors.deepPurple,
            'lastUpdated': DateTime.now().toIso8601String(),
          }
        ],
      },
      {
        'date': '2024-10-28', // Next week
        'appointments': [
          {
            'id': '9',
            'name': 'Maria Garcia',
            'type': 'Bridal Package',
            'doneBy': 'Emma White',
            'startTime': '10:00 AM',
            'endTime': '2:00 PM',
            'total': 'IQD250',
            'isCompleted': false,
            'colorBar': Colors.red,
            'lastUpdated': DateTime.now().toIso8601String(),
          }
        ],
      }
    ];
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final dayAppointments = _appointments.firstWhere(
      (day) => day['date'] == dateString,
      orElse: () => {'date': dateString, 'appointments': []},
    );
    return (dayAppointments['appointments'] as List<dynamic>)
        .map((app) => Appointment.fromJson(app))
        .toList();
  }

  List<Appointment> getTodayAppointments() {
    final now = DateTime.now();
    return getAppointmentsForDate(now);
  }

  Future<void> fetchAppointments() async {
    if (_isSyncing) return;

    try {
      _isSyncing = true;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(Duration(seconds: 1));

      // For development/demo purposes, reload the dummy data
      // This will reflect any changes made to the dummy data in the code
      _loadInitialData();

      // TODO: In production, replace with actual API call:
      // final response = await apiClient.getAppointments(lastSyncTime: _lastSyncTime);
      // _appointments = response.data;

      _lastSyncTime = DateTime.now();
    } catch (e) {
      print('Error fetching appointments: $e');
      // TODO: Handle error appropriately
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> addAppointment(DateTime date, Appointment appointment) async {
    try {
      // TODO: Implement API call to create appointment
      // await apiClient.createAppointment(appointment.toJson());

      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final dayIndex =
          _appointments.indexWhere((day) => day['date'] == dateString);

      if (dayIndex != -1) {
        _appointments[dayIndex]['appointments'].add(appointment.toJson());
      } else {
        _appointments.add({
          'date': dateString,
          'appointments': [appointment.toJson()],
        });
      }

      notifyListeners();
    } catch (e) {
      print('Error adding appointment: $e');
      throw e;
    }
  }

  Future<void> updateAppointment(
      DateTime date, Appointment updatedAppointment) async {
    try {
      // TODO: Implement API call to update appointment
      // await apiClient.updateAppointment(updatedAppointment.id, updatedAppointment.toJson());

      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final dayIndex =
          _appointments.indexWhere((day) => day['date'] == dateString);

      if (dayIndex != -1) {
        final appIndex = _appointments[dayIndex]['appointments']
            .indexWhere((app) => app['id'] == updatedAppointment.id);

        if (appIndex != -1) {
          _appointments[dayIndex]['appointments'][appIndex] =
              updatedAppointment.toJson();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating appointment: $e');
      throw e;
    }
  }

  Future<void> removeAppointment(DateTime date, String appointmentId) async {
    try {
      // TODO: Implement API call to delete appointment
      // await apiClient.deleteAppointment(appointmentId);

      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final dayIndex =
          _appointments.indexWhere((day) => day['date'] == dateString);

      if (dayIndex != -1) {
        _appointments[dayIndex]['appointments']
            .removeWhere((app) => app['id'] == appointmentId);

        if (_appointments[dayIndex]['appointments'].isEmpty) {
          _appointments.removeAt(dayIndex);
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error removing appointment: $e');
      throw e;
    }
  }
}
