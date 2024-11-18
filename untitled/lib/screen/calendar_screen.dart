import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // 초기 선택 날짜를 현재 날짜로 지정
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nano Calendar'),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDate,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            locale: "ko_KR",
            // 캘린더에서 날짜가 선택될때 이벤트
            onDaySelected: onDaySelected,
            // 특정 날짜가 선택된 날짜와 동일한지 여부 판단
            selectedDayPredicate: (date) {
              return isSameDay(selectedDate, date);
            },

            headerStyle: HeaderStyle(
              titleCentered: true, // 타이틀 가운데 정렬
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMM(locale).format(date), // 타이틀 유형
              formatButtonVisible: false, // 헤더 버튼 숨김
              titleTextStyle: const TextStyle( // 타이틀 텍스트 스타일
                fontSize: 20.0,
                color: Color(0xFF000000),
              ),
            ),

            calendarStyle: const CalendarStyle(
              // today 표시 여부
              isTodayHighlighted : true,
              // today 글자 조정
              todayTextStyle : TextStyle(
                color: Color(0xFFFAFAFA),
                fontSize: 16.0,
              ),
              // today 모양 조정
              todayDecoration : BoxDecoration(
                color: Color(0xFF99D6FF),
                shape: BoxShape.circle,
              ),
              // selectedDay 글자 조정
              selectedTextStyle : TextStyle(
                color: Color(0xFFFAFAFA),
                fontSize: 16.0,
              ),
              // selectedDay 모양 조정
              selectedDecoration : BoxDecoration(
                color: Color(0xFF1976D2),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // 달력에서 날짜가 선택됐을 때 호출되는 콜백 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}