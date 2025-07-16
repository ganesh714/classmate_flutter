import 'package:flutter/material.dart';

class AttendanceCalcPage extends StatelessWidget {
  const AttendanceCalcPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Calculator')),
      body: const Center(child: Text('Attendance Calculator Page')),
    );
  }
} 