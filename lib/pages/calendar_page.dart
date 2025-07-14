import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const Center(
        child: Text(
          'Coming Soon: Calendar View',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
