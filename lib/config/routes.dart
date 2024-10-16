import 'package:flutter/material.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/base_layout.dart';
import '../presentation/pages/login.dart';
import '../presentation/pages/CalendarPage.dart';
import '../presentation/pages/add_appointment.dart';
import '../presentation/pages/services.dart'; // Add this import

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => LoginPage(),
  '/home': (context) => BaseLayout(child: HomePage()),
  '/calendar': (context) => BaseLayout(child: CalendarPage()),
  '/add_appointment': (context) => AddAppointment(),
  '/services': (context) => ServicesPage(), // Add this line
  // Add more routes as needed
};