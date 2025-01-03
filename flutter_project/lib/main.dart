import 'package:flutter/material.dart';
import 'package:flutter_project/create.dart';
import 'package:flutter_project/profile.dart';
import 'package:flutter_project/schedule.dart';
import 'package:flutter_project/drafts.dart';
// Çıkış sayfasını ekleyin
import 'package:provider/provider.dart';
import 'authprovider.dart';
import 'login.dart';
import 'dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaSync',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: _getInitialRoute(context),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/drafts': (context) => DraftPage(),
        '/create': (context) => const CreatePage(),
        '/profile': (context) => const ProfilePage(),
        '/schedule': (context) => SchedulePage(),
      },
    );
  }

  String _getInitialRoute(BuildContext context) {
    final token = Provider.of<AuthProvider>(context).token;
    return token == null ? '/login' : '/dashboard';
  }
}
