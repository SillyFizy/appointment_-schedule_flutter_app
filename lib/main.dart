import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import './presentation/providers/service_provider.dart';
import './presentation/providers/appointment_provider.dart';
import './presentation/providers/client_provider.dart'; // Add this import

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => AppointmentProvider()),
        ChangeNotifierProvider(
            create: (context) => ClientProvider()), // Add this line
      ],
      child: const BookingApp(),
    ),
  );
}
