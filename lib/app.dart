import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/pages/login.dart';
import 'presentation/pages/CalendarPage.dart';
import 'presentation/pages/add_appointment.dart';
import 'presentation/pages/services.dart';

class BookingApp extends StatelessWidget {
  const BookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      theme: appTheme,
      routes: {
        ...appRoutes,
        '/login': (context) => LoginPage(),
        '/calendar': (context) => CalendarPage(),
        '/add_appointment': (context) => AddAppointment(),
        '/services': (context) => ServicesPage(),
      },
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
    );
  }
}