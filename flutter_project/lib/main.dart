// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_project/schedule.dart';
import 'dashboard.dart';
import 'create.dart';
import 'login.dart';
import 'profile.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'dashboard',
      routes: {
        'dashboard': (context) => const DashboardPage(),
        'create': (context) => const CreatePage(),
        'profile': (context) => const ProfilePage(),
        'schedule': (context) => const SchedulePage(),
        'login': (context) => const LoginPage(),
      },
    );
  }
}
