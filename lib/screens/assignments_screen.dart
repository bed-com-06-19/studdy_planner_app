import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Assignments"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      body: const Center(
        child: Text(
          "Assignments Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}