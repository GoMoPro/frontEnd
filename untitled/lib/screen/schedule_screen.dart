import 'package:flutter/material.dart';

class _Time extends StatelessWidget {
  final int startTime; // 시작 시간
  final int endTime; // 종료 시간

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Color(0xFF1976D2),
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
        Text(
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        )
      ],
    );
  }
}

class _Content extends StatelessWidget{
  final String content; // 내용

  const _Content({
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Expanded(child: Text(content),);
  }
}

class ScheduleCard extends StatelessWidget{
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Color(0xFF1976D2),
        ),
        borderRadius: BorderRadius.circular(8.0)
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child : IntrinsicHeight(
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(startTime: startTime, endTime: endTime),
              SizedBox(width: 16.0,),
              _Content(content: content),
              SizedBox(width: 16.0,)
            ],
          )
        )
      ),
    )
  }
}