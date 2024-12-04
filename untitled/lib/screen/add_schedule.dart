// screens/add_schedule.dart
// 필요한 Flutter 및 Firebase 관련 패키지 임포트
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // 텍스트 입력 제어를 위해 추가
import 'package:intl/intl.dart'; // 날짜 형식 변경을 위해 추가
import '../widgets/custom_button.dart';
import 'home_screen.dart';

// 일정 추가 화면 위젯 클래스 정의
class AddSchedule extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜
  final Map<String, dynamic>? existingSchedule; // 기존 일정 정보, 없을 수도 있음 (null 허용)

  const AddSchedule({Key? key, required this.selectedDate, this.existingSchedule}) : super(key: key);

  @override
  _AddScheduleState createState() => _AddScheduleState(); // 상태 객체 생성
}

class _AddScheduleState extends State<AddSchedule> {
  // 일정 관련 필드 정의
  late String scheduleTitle; // 일정 제목
  late TimeOfDay morningTime; // 시작 시간
  late TimeOfDay afternoonTime; // 종료 시간
  late bool isAlarmEnabled; // 알람 설정 여부
  late String memo; // 메모 내용
  late Color? selectedColor; // 선택된 색상
  late bool isDailyRoutineEnabled; // 하루 종일 여부

  @override
  void initState() {
    super.initState();

    // 기존 일정이 있다면 초기 데이터를 설정하고, 없다면 기본값 설정
    if (widget.existingSchedule != null) {
      final schedule = widget.existingSchedule!; // 기존 일정 데이터 가져오기
      print("초기화되는 값들: $schedule"); // 디버깅을 위한 로그 출력

      // 기존 일정 정보를 가져와 각 필드에 초기화
      scheduleTitle = schedule['content'] ?? ''; // 일정 제목
      morningTime = schedule['startTime'] ?? TimeOfDay(hour: 6, minute: 00); // 시작 시간
      afternoonTime = schedule['endTime'] ?? TimeOfDay(hour: 18, minute: 00); // 종료 시간
      isAlarmEnabled = schedule['isAlarmEnabled'] ?? false; // 알람 설정 여부
      memo = schedule['memo'] ?? ''; // 메모 내용
      selectedColor = schedule['color']; // 선택된 색상
      isDailyRoutineEnabled = schedule['isDailyRoutineEnabled'] ?? false; // 하루 종일 설정 여부
    } else {
      // 기존 일정이 없는 경우 기본값 설정
      scheduleTitle = '';
      morningTime = TimeOfDay(hour: 8, minute: 30);
      afternoonTime = TimeOfDay(hour: 14, minute: 30);
      isAlarmEnabled = true;
      memo = '';
      selectedColor = Colors.blue;
      isDailyRoutineEnabled = false;
    }
  }

  // 화면 UI를 빌드하는 메서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 추가")), // 상단에 제목 표시
      body: RoutineSettingsScreen(
        selectedDate: widget.selectedDate, // 선택된 날짜 전달
        scheduleTitle: scheduleTitle, // 일정 제목 전달
        morningTime: morningTime, // 시작 시간 전달
        afternoonTime: afternoonTime, // 종료 시간 전달
        isAlarmEnabled: isAlarmEnabled, // 알람 설정 여부 전달
        memo: memo, // 메모 내용 전달
        selectedColor: selectedColor, // 선택된 색상 전달
        isDailyRoutineEnabled: isDailyRoutineEnabled, // 하루 종일 설정 여부 전달
        // 상위 위젯에서 변경된 데이터를 받는 콜백
        onScheduleChange: (updatedSchedule) {
          setState(() {
            // 전달받은 일정 데이터를 각 필드에 업데이트
            scheduleTitle = updatedSchedule['title'];
            morningTime = updatedSchedule['morningTime'];
            afternoonTime = updatedSchedule['afternoonTime'];
            isAlarmEnabled = updatedSchedule['isAlarmEnabled'];
            memo = updatedSchedule['memo'];
            selectedColor = updatedSchedule['color'];
            isDailyRoutineEnabled = updatedSchedule['isDailyRoutineEnabled'];
          });
        },
      ),
    );
  }
}

// RoutineSettingsScreen 클래스 정의: 일정을 설정할 수 있는 화면
class RoutineSettingsScreen extends StatefulWidget {
  // 위젯 생성 시 필요한 필드들 정의
  final DateTime selectedDate;
  final String scheduleTitle;
  final TimeOfDay morningTime;
  final TimeOfDay afternoonTime;
  final bool isAlarmEnabled;
  final String memo;
  final Color? selectedColor;
  final bool isDailyRoutineEnabled;
  final Function(Map<String, dynamic>) onScheduleChange; // 일정 변경 시 호출되는 콜백

  const RoutineSettingsScreen({
    Key? key,
    required this.selectedDate,
    required this.scheduleTitle,
    required this.morningTime,
    required this.afternoonTime,
    required this.isAlarmEnabled,
    required this.memo,
    required this.selectedColor,
    required this.isDailyRoutineEnabled,
    required this.onScheduleChange,
  }) : super(key: key);

  @override
  _RoutineSettingsScreenState createState() => _RoutineSettingsScreenState();
}

class _RoutineSettingsScreenState extends State<RoutineSettingsScreen> {
  // 필드 정의
  late DateTime selectedDate;
  late TextEditingController titleController; // 일정 제목 입력을 위한 컨트롤러
  late TextEditingController memoController; // 메모 입력을 위한 컨트롤러
  bool isDailyRoutineEnabled = true; // 하루 종일 여부
  bool isAlarmEnabled = true; // 알람 설정 여부
  TimeOfDay morningTime = TimeOfDay(hour: 8, minute: 30); // 시작 시간 기본값
  TimeOfDay afternoonTime = TimeOfDay(hour: 14, minute: 30); // 종료 시간 기본값
  String memo = ''; // 메모 기본값
  String scheduleTitle = ''; // 일정 제목 기본값
  Color? selectedColor; // 선택된 색상

  @override
  void initState() {
    super.initState();
    // 전달받은 초기값을 컨트롤러 및 필드에 설정
    titleController = TextEditingController(text: widget.scheduleTitle);
    memoController = TextEditingController(text: widget.memo);

    selectedDate = widget.selectedDate;
    isAlarmEnabled = widget.isAlarmEnabled;
    morningTime = widget.morningTime;
    afternoonTime = widget.afternoonTime;
    memo = widget.memo;
    scheduleTitle = widget.scheduleTitle;
    selectedColor = widget.selectedColor;
    isDailyRoutineEnabled = widget.isDailyRoutineEnabled;
  }

  // 시간 선택 다이얼로그 표시 (오전/오후 시간 설정)
  Future<void> _selectTime(BuildContext context, bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? morningTime : afternoonTime,
    );
    if (picked != null) {
      setState(() {
        if (isMorning) {
          morningTime = picked;
        } else {
          afternoonTime = picked;
        }

        // 변경된 일정 데이터를 상위 위젯으로 전달
        widget.onScheduleChange({
          'title': scheduleTitle,
          'morningTime': morningTime,
          'afternoonTime': afternoonTime,
          'isAlarmEnabled': isAlarmEnabled,
          'memo': memo,
          'color': selectedColor,
          'isDailyRoutineEnabled': isDailyRoutineEnabled,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면 터치 시 키보드 숨기기
      },
      child: SingleChildScrollView( // 화면을 스크롤 가능하게 설정
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 입력 필드
              TextField(
                controller: titleController, // 제목 입력 컨트롤러 연결
                decoration: InputDecoration(
                  hintText: '제목 입력',
                  border: UnderlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\uAC00-\uD7A3\u1100-\u11FF\u3130-\u318F\u0000-\u007F]+')), // 한글 및 영어 입력 허용
                ],
                onChanged: (value) {
                  setState(() {
                    scheduleTitle = value;
                  });
                  // 변경 사항을 상위 위젯에 전달
                  widget.onScheduleChange({
                    'title': value,
                    'morningTime': morningTime,
                    'afternoonTime': afternoonTime,
                    'isAlarmEnabled': isAlarmEnabled,
                    'memo': memoController.text,
                    'color': selectedColor,
                    'isDailyRoutineEnabled': isDailyRoutineEnabled,
                  });
                },
              ),
              SizedBox(height: 24),

              // 하루 종일 설정 스위치
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer), // 시계 아이콘
                      SizedBox(width: 8),
                      Text('하루종일', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Switch(
                    value: isDailyRoutineEnabled,
                    onChanged: (value) {
                      setState(() {
                        isDailyRoutineEnabled = value;
                      });
                      // 변경 사항을 상위 위젯에 전달
                      widget.onScheduleChange({
                        'title': scheduleTitle,
                        'morningTime': morningTime,
                        'afternoonTime': afternoonTime,
                        'isAlarmEnabled': isAlarmEnabled,
                        'memo': memo,
                        'color': selectedColor,
                        'isDailyRoutineEnabled': isDailyRoutineEnabled,
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),

              // 시간 설정 섹션 (시작/종료 버튼)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('시간 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('시작', style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                            onPressed: () => _selectTime(context, true),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text('${morningTime.format(context)}', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('종료', style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                            onPressed: () => _selectTime(context, false),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text('${afternoonTime.format(context)}', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),

              // 알람 설정 스위치
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb), // 전구 아이콘
                      SizedBox(width: 8),
                      Text('알람 설정', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Switch(
                    value: isAlarmEnabled ?? false,
                    onChanged: (value) {
                      setState(() {
                        isAlarmEnabled = value;
                      });
                      // 변경 사항을 상위 위젯에 전달
                      widget.onScheduleChange({
                        'title': scheduleTitle,
                        'morningTime': morningTime,
                        'afternoonTime': afternoonTime,
                        'isAlarmEnabled': isAlarmEnabled,
                        'memo': memo,
                        'color': selectedColor,
                        'isDailyRoutineEnabled': isDailyRoutineEnabled,
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),

              // 메모 입력 필드
              TextField(
                controller: memoController,
                decoration: InputDecoration(
                  labelText: '메모',
                  icon: Icon(Icons.note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\uAC00-\uD7A3\u1100-\u11FF\u3130-\u318F\u0000-\u007F]+')), // 한글 및 영어 입력 허용
                ],
                maxLines: 8,
                onChanged: (value) {
                  setState(() {
                    memo = value;
                  });
                  widget.onScheduleChange({
                    'title': scheduleTitle,
                    'morningTime': morningTime,
                    'afternoonTime': afternoonTime,
                    'isAlarmEnabled': isAlarmEnabled,
                    'memo': value,
                    'color': selectedColor,
                    'isDailyRoutineEnabled': isDailyRoutineEnabled,
                  });
                },
              ),
              SizedBox(height: 140),

              // 색상 선택 옵션
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ColorOption(
                      color: Colors.red,
                      isSelected: selectedColor == Colors.red,
                      onTap: () {
                        setState(() {
                          selectedColor = Colors.red;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ColorOption(
                      color: Colors.orange,
                      isSelected: selectedColor == Colors.orange,
                      onTap: () {
                        setState(() {
                          selectedColor = Colors.orange;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ColorOption(
                      color: Colors.yellow,
                      isSelected: selectedColor == Colors.yellow,
                      onTap: () {
                        setState(() {
                          selectedColor = Colors.yellow;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ColorOption(
                      color: Colors.green,
                      isSelected: selectedColor == Colors.green,
                      onTap: () {
                        setState(() {
                          selectedColor = Colors.green;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ColorOption(
                      color: Colors.blue,
                      isSelected: selectedColor == Colors.blue,
                      onTap: () {
                        setState(() {
                          selectedColor = Colors.blue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // 취소 및 확인 버튼
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: '취소',
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false,
                        );
                      },
                      color: Colors.grey[400]!,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: '확인',
                      onPressed: () async {
                        if (scheduleTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('일정 제목을 입력해주세요.')));
                        } else {
                          final updatedSchedule = {
                            'date': DateFormat('yyyy-MM-dd').format(selectedDate.toLocal()), // 대한민국 시간대로 변경
                            'startTime': morningTime.format(context),
                            'endTime': afternoonTime.format(context),
                            'content': scheduleTitle,
                            'memo': memo,
                            'isAlarmEnabled': isAlarmEnabled,
                            'color': selectedColor?.value ?? Colors.blue.value,
                            'isDailyRoutineEnabled': isDailyRoutineEnabled,
                          };

                          await FirestoreService().saveSchedule(updatedSchedule);

                          Navigator.pop(context, updatedSchedule); // 수정된 일정 반환
                        }
                      },
                      color: Colors.blue[400]!,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose(); // 컨트롤러 해제
    memoController.dispose();
    super.dispose();
  }
}

// 색상 옵션 위젯 정의
class ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected; // 선택 여부
  final VoidCallback onTap; // 터치 이벤트 콜백

  ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
      ),
    );
  }
}

// Firestore 데이터베이스 서비스 클래스
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 일정 데이터 저장 함수
  Future<void> saveSchedule(Map<String, dynamic> scheduleData) async {
    try {
      await _firestore.collection('schedules').add(scheduleData);
      print("데이터 저장 성공!");
    } catch (e) {
      print("데이터 저장 실패: $e");
    }
  }
}


/*
1. Firebase Firestore와의 상호작용을 위해 먼저 FirebaseFirestore 인스턴스를 생성합니다.
   `final FirebaseFirestore _firestore = FirebaseFirestore.instance;`

2. saveSchedule 함수는 비동기 방식으로 작성되어, 일정 데이터를 저장하기 위해 `Future<void>` 형식을 반환합니다.
   즉, 이 함수는 Firestore에 데이터가 저장되길 기다려야 하며, 비동기로 처리되어 나머지 앱 흐름을 방해하지 않습니다.

3. Firestore 데이터베이스의 "schedules"라는 컬렉션에 새로운 문서를 추가합니다.
   `await _firestore.collection('schedules').add(scheduleData);`
   - `collection('schedules')`: Firestore의 "schedules" 컬렉션에 접근합니다. 이 컬렉션이 이미 존재하지 않으면 Firestore에서 자동으로 생성됩니다.
   - `add(scheduleData)`: 전달된 scheduleData를 Firestore에 새 문서로 추가합니다.
     - `scheduleData`는 일정 데이터를 포함하는 Map 형태이며, 이 데이터는 다음과 같은 필드를 포함합니다:
       - 'date': 일정 날짜 (형식: "yyyy-MM-dd", 예: "2024-12-04")
       - 'startTime': 일정 시작 시간 (형식: "오전 8:30" 또는 "오후 2:30" 등, 로컬 형식으로 표시)
       - 'endTime': 일정 종료 시간 (형식: "오후 6:00" 등)
       - 'content': 일정 제목 (예: "프로젝트 회의")
       - 'memo': 메모 내용 (예: "회의 준비 자료 필요")
       - 'isAlarmEnabled': 알람 설정 여부 (Boolean 값, 예: true/false)
       - 'color': 일정의 색상 코드 (정수 값, 예: Colors.blue.value)
       - 'isDailyRoutineEnabled': 하루 종일 설정 여부 (Boolean 값)

4. 데이터가 정상적으로 Firestore에 저장되면 "데이터 저장 성공!"이라는 메시지가 출력되고, 오류가 발생할 경우 catch 블록에서 해당 오류 메시지를 출력합니다.
   `print("데이터 저장 실패: $e");`
*/
