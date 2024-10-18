import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import './presentation/providers/service_provider.dart';  // Make sure to create this file in the same directory

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ServiceProvider(),
      child: const BookingApp(),
    ),
  );
}