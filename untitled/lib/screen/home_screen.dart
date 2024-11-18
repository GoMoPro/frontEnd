import 'package:flutter/material.dart';
import 'package:untitled/screen/calendar_screen.dart';
import 'package:untitled/screen/schedule_screen.dart';
import 'package:untitled/screen/add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Nano Calendar"),
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF1976D2)
      ),
      body: SafeArea(
          child: Column(
            children: [
              CalendarScreen(selectedDate: selectedDate, onDaySelected: onDaySelected,),
              ScheduleCard(startTime: 12, endTime: 14, content: "고모프")
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1976D2),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddScreen())
          );
        },
      ),
    );
  }
  void onDaySelected(DateTime selectedDate, DateTime focuesdDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}