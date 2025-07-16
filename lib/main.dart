import 'package:flutter/material.dart';
import '/features/auth/login_page.dart';
import '/features/home/home.dart';
import 'index.dart';
import '/theme/app_theme.dart';
import 'features/dashboard_page.dart';
import 'features/chatbot_page.dart';
import '/features/notes_page.dart';
import '/features/task_manager_page.dart';
import 'features/attendance_calc_page.dart';
import 'features/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Classmate AI',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const IndexPage(),
        '/login': (context) => const LoginPage(),
        '/home' : (context) => const HomePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/notes': (context) => const NotesPage(),
        '/task_manager': (context) => const TaskManagerPage(),
        '/attendance_calc': (context) => const AttendanceCalcPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}