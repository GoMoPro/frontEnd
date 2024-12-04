import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:untitled/screen/Timebox_screen.dart';
import 'package:untitled/screen/add_schedule.dart';
import 'package:untitled/screen/calendar_screen.dart';
import 'package:untitled/screen/schedule_screen.dart';

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

  // 스케줄 데이터 리스트
  final List<Map<String, dynamic>> schedules = [
    {
      'date': DateTime.utc(2024, 12, 2),
      'startTime': TimeOfDay(hour: 9, minute: 30),
      'endTime': TimeOfDay(hour: 11, minute: 30),
      'content': "고모프",
      'memo': "플러터 및 파이어베이스 회의",
      'color': Colors.blue,
      'isAlarmEnabled': false, // 알람 상태 추가
    },
    {
      'date': DateTime.utc(2024, 12, 3),
      'startTime': TimeOfDay(hour: 13, minute: 30),
      'endTime': TimeOfDay(hour: 18, minute: 0),
      'content': "스터디",
      'memo': "알고리즘 문제 풀이",
      'color': Colors.green,
      'isAlarmEnabled': true, // 알람 활성화 상태
    },
    {
      'date': DateTime.utc(2024, 12, 2),
      'startTime': TimeOfDay(hour: 14, minute: 30),
      'endTime': TimeOfDay(hour: 16, minute: 20),
      'content': "코드 리뷰",
      'memo': "팀 프로젝트 코드 점검",
      'color': Colors.red,
      'isAlarmEnabled': false, // 알람 비활성화 상태
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 선택된 날짜의 스케줄 필터링
    final filteredSchedules = schedules.where((schedule) {
      return schedule['date'] == selectedDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: const Text("Nano Calendar"),
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF1976D2)),
      body: SafeArea(
          child: Column(
            children: [
              CalendarScreen(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
              ),
              // 선택된 날짜의 스케줄 표시
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSchedules.length,
                  itemBuilder: (context, index) {
                    final schedule = filteredSchedules[index];
                    return Slidable(
                      key: Key(schedule['content']),
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // 편집 동작
                              print(schedule);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddSchedule(
                                    selectedDate: selectedDate,
                                    existingSchedule: schedule, // 기존 일정 전달
                                  ),
                                ),
                              ).then((updatedSchedule) {
                                if (updatedSchedule != null) {
                                  setState(() {
                                    int index = schedules.indexOf(schedule); // 기존 일정의 인덱스를 찾아
                                    schedules[index] = updatedSchedule; // 해당 일정을 수정된 내용으로 업데이트
                                  });
                                }
                              });
                            },
                            backgroundColor: Colors.blue,
                            icon: Icons.edit,
                            label: '편집',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // 삭제 동작
                              setState(() {
                                schedules.removeAt(index); // 일정 삭제
                              });
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: '삭제',
                          ),
                        ],
                      ),
                      child: ScheduleCard(
                        startTime: schedule['startTime'],
                        endTime: schedule['endTime'],
                        content: schedule['content'],
                        memo: schedule['memo'],
                        color: schedule['color'],
                        isAlarmEnabled: schedule['isAlarmEnabled'],
                        onAlarmToggle: () {
                          setState(() {
                            // 알람 상태 변경
                            schedule['isAlarmEnabled'] = !schedule['isAlarmEnabled'];
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1976D2),
        onPressed: () async {
          // AddSchedule 화면에서 데이터를 받아옴
          final newSchedule = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSchedule(selectedDate: selectedDate), // 선택된 날짜 전달
            ),
          );
          if (newSchedule != null) {
            setState(() {
              schedules.add(newSchedule); // 새로운 일정 추가
            });
          }
        },
        child: const Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Name"),
              accountEmail: Text("accountEmail"),
              decoration: BoxDecoration(color: Color(0xFF1976D2)),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              iconColor: const Color(0xFF1976D2),
              focusColor: const Color(0xFF1976D2),
              title: const Text('월간 달력'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              iconColor: const Color(0xFF1976D2),
              focusColor: const Color(0xFF1976D2),
              title: const Text('주간 타임박스'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimeboxScreen(schedules: schedules)));
              },
              trailing: const Icon(Icons.navigate_next),
            )
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
