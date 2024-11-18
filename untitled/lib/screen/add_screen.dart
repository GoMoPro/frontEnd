import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenSheet();
}

class _AddScreenSheet extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("일정 추가"),
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF1976D2)
      ),
    );
  }
}