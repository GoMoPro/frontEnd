import 'package:flutter/material.dart';

class _Time extends StatelessWidget {
  final TimeOfDay startTime; // 시작 시간
  final TimeOfDay endTime; // 종료 시간

  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key
  }) : super(key: key);

  // TimeOfDay를 00:00 형식의 문자열로 변환하는 함수
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

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
          formatTime(startTime),
          style: textStyle,
        ),
        Text(
          formatTime(endTime),
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget{
  final String content; // 내용
  final String memo;

  const _Content({
    required this.content,
    required this.memo,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          // 메모가 비어있지 않으면 표시
          if (memo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 30.0, // 적절한 높이를 설정해서 텍스트가 넘어가지 않도록 조정
                child: SingleChildScrollView(  // 텍스트가 넘치면 스크롤 가능
                  child: Text(
                    '메모: $memo',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 말줄임 표시
                    maxLines: 2,  // 텍스트가 2줄을 넘지 않도록 설정
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget{
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String content;
  final String memo;
  final Color color;
  final bool isAlarmEnabled; // 알람 여부 추가
  final VoidCallback onAlarmToggle; // 알람 토글 콜백 추가

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.memo,
    required this.color,
    required this.isAlarmEnabled, // 알람 여부 매개변수 추가
    required this.onAlarmToggle, // 알람 토글 콜백 매개변수 추가
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: const Color(0xFF1976D2),
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
              _Content(content: content, memo: memo),
              SizedBox(width: 16.0,),
              // 우측 가운데에 동그라미 색상 표시
              Center(
                child: Container(
                  width: 24.0, // 동그라미의 너비
                  height: 24.0, // 동그라미의 높이
                  decoration: BoxDecoration(
                    color: color, // 동그라미 색상
                    shape: BoxShape.circle, // 원형으로 설정
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              // 알람 아이콘 버튼
              Center(
                child: IconButton(
                  icon: Icon(
                    isAlarmEnabled
                        ? Icons.notifications // 알람이 활성화된 경우
                        : Icons.notifications_none, // 알람이 비활성화된 경우
                    color: isAlarmEnabled ? Colors.black : Colors.grey, // 색상 변경
                  ),
                  onPressed: onAlarmToggle, // 알람 상태 변경 함수 호출
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}