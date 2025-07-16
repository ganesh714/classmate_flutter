import 'package:flutter/material.dart';

class TaskManagerPage extends StatelessWidget {
  const TaskManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: const Center(child: Text('Task Manager Page')),
    );
  }
} 