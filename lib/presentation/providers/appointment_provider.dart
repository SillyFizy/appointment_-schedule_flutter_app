import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String id;
  final String name;
  final String phoneNumber;
  final String type;
  final String doneBy;
  final String startTime;
  final String endTime;
  final String total;
  final bool isCompleted;
  final Color colorBar;
  final DateTime lastUpdated;
  final List<ServiceAppointment> services;
  final String? additionalMessage;
  final String reminder;

  Appointment({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.type,
    required this.doneBy,
    required this.startTime,
    required this.endTime,
    required this.total,
    required this.isCompleted,
    required this.colorBar,
    required this.lastUpdated,
    required this.services,
    this.additionalMessage,
    required this.reminder,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    List<ServiceAppointment> parseServices(dynamic servicesJson) {
      if (servicesJson == null) return [];

      if (servicesJson is List<dynamic>) {
        return servicesJson.map((service) {
          if (service is String) {
            return ServiceAppointment(
              name: service,
              startTime: json['startTime'] as String? ?? '',
              endTime: json['endTime'] as String? ?? '',
              doneBy: json['doneBy'] as String? ?? '',
              price: 0,
            );
          } else if (service is Map<String, dynamic>) {
            return ServiceAppointment.fromJson(service);
          }
          return ServiceAppointment(
            name: 'Unknown Service',
            startTime: '',
            endTime: '',
            doneBy: '',
            price: 0,
          );
        }).toList();
      }
      return [];
    }

    return Appointment(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      type: json['type'] as String? ?? '',
      doneBy: json['doneBy'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      total: json['total'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      colorBar: json['colorBar'] is int
          ? Color(json['colorBar'] as int)
          : Colors.blue,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
      services: parseServices(json['services']),
      additionalMessage: json['additionalMessage'] as String?,
      reminder: json['reminder'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'type': type,
      'doneBy': doneBy,
      'startTime': startTime,
      'endTime': endTime,
      'total': total,
      'isCompleted': isCompleted,
      'colorBar': colorBar.value,
      'lastUpdated': lastUpdated.toIso8601String(),
      'services': services.map((s) => s.toJson()).toList(),
      'additionalMessage': additionalMessage,
      'reminder': reminder,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Appointment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode => id.hashCode ^ lastUpdated.hashCode;
}

class ServiceAppointment {
  final String name;
  final String startTime;
  final String endTime;
  final String doneBy;
  final int price;
  final String? doctorId;

  ServiceAppointment({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.doneBy,
    required this.price,
    this.doctorId,
  });

  factory ServiceAppointment.fromJson(Map<String, dynamic> json) {
    return ServiceAppointment(
      name: json['name'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      doneBy: json['doneBy'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      doctorId: json['doctorId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'doneBy': doneBy,
      'price': price,
      'doctorId': doctorId,
    };
  }
}

class AppointmentProvider with ChangeNotifier {
  List<Map<String, dynamic>> _appointments = [];
  Map<String, DateTime> _lastUpdateTimes = {};
  Set<String> _newAppointments = {};
  DateTime? _lastSyncTime;
  bool _isSyncing = false;

  List<Map<String, dynamic>> get appointments => List.from(_appointments);
  bool get isSyncing => _isSyncing;

  AppointmentProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _appointments = _getDummyData();
    // Initialize last update times for existing appointments
    for (var dayAppointments in _appointments) {
      for (var appointment
          in (dayAppointments['appointments'] as List<dynamic>)) {
        final id = appointment['id'] as String;
        final lastUpdated =
            DateTime.parse(appointment['lastUpdated'] as String);
        _lastUpdateTimes[id] = lastUpdated;
      }
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> _getDummyData() {
    return [
      {
        'date': '2024-10-29',
        'appointments': [
          {
            'id': '1',
            'name': 'Sarah Johnson',
            'phoneNumber': '+1 234-567-8901',
            'type': 'Full Set Manicure',
            'doneBy': 'Emma White',
            'startTime': '9:00 AM',
            'endTime': '10:30 AM',
            'total': 'IQD75',
            'isCompleted': false,
            'colorBar': Colors.blue.value,
            'lastUpdated': DateTime.now().toIso8601String(),
            'services': [
              {
                'name': 'Full Set Manicure',
                'startTime': '9:00 AM',
                'endTime': '10:00 AM',
                'doneBy': 'Emma White',
                'price': 75,
              },
              {
                'name': 'Hand Massage',
                'startTime': '10:00 AM',
                'endTime': '10:30 AM',
                'doneBy': 'Emma White',
                'price': 25,
              }
            ],
            'reminder': '30 minutes before',
          },
          {
            'id': '2',
            'name': 'Michael Chen',
            'phoneNumber': '+1 234-567-8902',
            'type': 'Haircut & Styling',
            'doneBy': 'James Wilson',
            'startTime': '11:00 AM',
            'endTime': '12:00 PM',
            'total': 'IQD45',
            'isCompleted': false,
            'colorBar': Colors.green.value,
            'lastUpdated': DateTime.now().toIso8601String(),
            'services': [
              {
                'name': 'Haircut & Styling',
                'startTime': '11:00 AM',
                'endTime': '12:00 PM',
                'doneBy': 'James Wilson',
                'price': 45,
              }
            ],
            'reminder': '1 hour before',
          },
        ],
      },
    ];
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final dayAppointments = _appointments.firstWhere(
      (day) => day['date'] == dateString,
      orElse: () => {
        'date': dateString,
        'appointments': <Map<String, dynamic>>[]
      } as Map<String, dynamic>,
    );
    return ((dayAppointments['appointments'] ?? []) as List<dynamic>)
        .map((app) => Appointment.fromJson(app as Map<String, dynamic>))
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

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Get new data
      final newData = _getDummyData();

      // Compare and update only changed appointments
      for (var dayData in newData) {
        final dateString = dayData['date'] as String;
        final newAppointments = dayData['appointments'] as List<dynamic>;

        // Find or create the day in existing appointments
        var existingDayIndex =
            _appointments.indexWhere((day) => day['date'] == dateString);
        if (existingDayIndex == -1) {
          _appointments.add({'date': dateString, 'appointments': []});
          existingDayIndex = _appointments.length - 1;
        }

        // Process each appointment
        for (var newAppointment in newAppointments) {
          final id = newAppointment['id'] as String;
          final newLastUpdated =
              DateTime.parse(newAppointment['lastUpdated'] as String);

          // Check if this is a new or updated appointment
          if (!_lastUpdateTimes.containsKey(id)) {
            // New appointment
            _newAppointments.add(id);
            _lastUpdateTimes[id] = newLastUpdated;
            (_appointments[existingDayIndex]['appointments'] as List<dynamic>)
                .add(newAppointment);
          } else if (newLastUpdated.isAfter(_lastUpdateTimes[id]!)) {
            // Updated appointment
            _lastUpdateTimes[id] = newLastUpdated;
            var appointments = _appointments[existingDayIndex]['appointments']
                as List<dynamic>;
            var index = appointments.indexWhere((a) => a['id'] == id);
            if (index != -1) {
              appointments[index] = newAppointment;
            }
          }
        }
      }

      _lastSyncTime = DateTime.now();
    } catch (e) {
      print('Error fetching appointments: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> addAppointment(
    DateTime date, {
    required String clientName,
    required List<String> serviceNames,
    required List<ServiceAppointment> services,
    required String doneBy,
    required String startTime,
    required String endTime,
    required String total,
    required String reminder,
    String? additionalMessage,
  }) async {
    try {
      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      final DateTime now = DateTime.now();

      final Map<String, Object> newAppointment = {
        'id': id,
        'name': clientName,
        'phoneNumber': '',
        'type': serviceNames.join(', '),
        'doneBy': doneBy,
        'startTime': startTime,
        'endTime': endTime,
        'total': total,
        'isCompleted': false,
        'colorBar': Colors.blue.value,
        'lastUpdated': now.toIso8601String(),
        'services': services
            .map((s) => {
                  'name': s.name,
                  'startTime': s.startTime,
                  'endTime': s.endTime,
                  'doneBy': s.doneBy,
                  'price': s.price,
                } as Map<String, Object>)
            .toList(),
        'reminder': reminder,
      };

      if (additionalMessage != null) {
        newAppointment['additionalMessage'] = additionalMessage;
      }

      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final dayIndex =
          _appointments.indexWhere((day) => day['date'] == dateString);

      if (dayIndex != -1) {
        (_appointments[dayIndex]['appointments'] as List<dynamic>)
            .add(newAppointment);
      } else {
        _appointments.add({
          'date': dateString,
          'appointments': <Map<String, Object>>[newAppointment],
        });
      }

      // Track the new appointment
      _newAppointments.add(id);
      _lastUpdateTimes[id] = now;

      notifyListeners();
    } catch (e) {
      print('Error adding appointment: $e');
      throw e;
    }
  }

  Future<void> removeAppointment(DateTime date, String appointmentId) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final dayIndex =
          _appointments.indexWhere((day) => day['date'] == dateString);

      if (dayIndex != -1) {
        (_appointments[dayIndex]['appointments'] as List<dynamic>)
            .removeWhere((app) => app['id'] == appointmentId);

        if ((_appointments[dayIndex]['appointments'] as List<dynamic>)
            .isEmpty) {
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
