import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../blocs/appointment_card.dart';
import 'dart:async';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime currentDate;
  ScrollController _scrollController = ScrollController();
  Timer? _refreshTimer;
  int _refreshCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
      _refreshAppointments(); // Initial fetch
    });

    // Set up periodic refresh every 30 seconds
    _refreshTimer = Timer.periodic(Duration(seconds: 30), (_) {
      _refreshAppointments();
      print("Auto refresh triggered. Count: ${++_refreshCount}");
    });
  }

  Future<void> _refreshAppointments() async {
    if (_isLoading) return; // Prevent multiple simultaneous refreshes

    setState(() {
      _isLoading = true;
    });

    try {
      final appointmentProvider =
          Provider.of<AppointmentProvider>(context, listen: false);
      await appointmentProvider.fetchAppointments();
    } catch (e) {
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh appointments. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: _buildCenteredTitle(),
                    actions: [
                      if (_isLoading)
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      TextButton(
                        child: Text(
                          'Today',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        onPressed: _goToToday,
                      ),
                    ],
                  ),
                  _buildWeekCalendar(),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAppointments,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: _buildDaySchedule(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_appointment');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  Widget _buildCenteredTitle() {
    return Container(
      height: 40,
      width: 280,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '${_getMonthName(currentDate.month)}, ${currentDate.year}',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          SizedBox(width: 4),
          _buildMonthDropdown(),
        ],
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return Container(
      width: 24,
      height: 24,
      child: PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 24),
        onSelected: (int month) {
          setState(() {
            currentDate = DateTime(currentDate.year, month, currentDate.day);
          });
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToSelectedDay());
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          for (int i = 1; i <= 12; i++)
            PopupMenuItem<int>(
              value: i,
              child: Text(_getMonthName(i)),
            ),
        ],
      ),
    );
  }

  void _goToToday() {
    setState(() {
      currentDate = DateTime.now();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDay());
    _refreshAppointments();
  }

  Widget _buildWeekCalendar() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      height: 110,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _daysInMonth(currentDate.year, currentDate.month),
        itemBuilder: (context, index) {
          final day = index + 1;
          final date = DateTime(currentDate.year, currentDate.month, day);
          final isSelected = date.day == currentDate.day &&
              date.month == currentDate.month &&
              date.year == currentDate.year;
          return _buildDayItem(
            date: date,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                currentDate = date;
              });
              _scrollToSelectedDay();
            },
          );
        },
      ),
    );
  }

  void _scrollToSelectedDay() {
    final double itemWidth = 70.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetPosition = (currentDate.day - 1) * itemWidth;
    final double screenCenter = screenWidth / 2;
    final double scrollTo = targetPosition - screenCenter + (itemWidth / 2);

    _scrollController.animateTo(
      scrollTo.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildDayItem({
    required DateTime date,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getDayName(date.weekday),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySchedule() {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        final appointments =
            appointmentProvider.getAppointmentsForDate(currentDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _formatDateForDisplay(currentDate),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: appointments.isEmpty
                  ? Center(child: Text('No appointments for this day'))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
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
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1].split(' ')[0]);
    final isPM = time.toLowerCase().contains('pm');
    return DateTime(2024, 1, 1, isPM && hour != 12 ? hour + 12 : hour, minute);
  }

  String _formatDateForDisplay(DateTime date) {
    return '${_getDayName(date.weekday)}, ${_getMonthName(date.month)} ${date.day}';
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  String _getDayName(int weekday) {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return dayNames[weekday - 1];
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
