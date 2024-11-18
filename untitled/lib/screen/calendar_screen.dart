import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {

  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  CalendarScreen({
    required this.onDaySelected,
    required this.selectedDate
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      onDaySelected: onDaySelected, // 날짜 선택 시 실행할 함수

      selectedDayPredicate: (date) => // 선택할 날짜를 구분할 로직
      date.year == selectedDate.year&&
      date.month == selectedDate.month&&
      date.day == selectedDate.day,

      focusedDay: DateTime.now(), // 현재 달력 위치
      firstDay: DateTime(1950), // 달력의 처음 날짜
      lastDay: DateTime(2050), // 달력의 마지막 날짜
      locale: "ko_KR",
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
        // today 글자 및 모양 조정
        todayTextStyle : TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 16.0,
        ),
        todayDecoration : BoxDecoration(
          color: Color(0xFF99D6FF),
          shape: BoxShape.circle,
        ),
        // selectedDay 글자 및 모양 조정
        selectedTextStyle : TextStyle(
          color: Color(0xFFFAFAFA),
          fontSize: 16.0,
        ),
        selectedDecoration : BoxDecoration(
          color: Color(0xFF1976D2),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
