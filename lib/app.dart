import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/pages/login.dart';
import 'presentation/pages/CalendarPage.dart';
import 'presentation/pages/add_appointment.dart';
import 'presentation/pages/services.dart'; // Add this import

class BookingApp extends StatelessWidget {
  const BookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      theme: appTheme,
      routes: {
        ...appRoutes,
        '/calendar': (context) => CalendarPage(),
        '/add_appointment': (context) => AddAppointment(),
        '/services': (context) => ServicesPage(), // Add this line
      },
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
    );
  }
}
