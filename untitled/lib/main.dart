import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Firebase 설정 파일을 불러옵니다.

import 'screen/login_screen.dart'; // 로그인 화면을 불러옵니다.
import 'package:intl/date_symbol_data_local.dart'; // locale 정보를 불러옴.

void main() async {
  // Firebase 초기화를 위해 Flutter 엔진과의 바인딩을 설정합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase를 초기화합니다.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // locale 정보 초기화
  await initializeDateFormatting();

  // 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nano Calendar',
      theme: ThemeData(
        primaryColor: const Color(0xFF1976D2), // 앱의 기본 색상을 파란색으로 설정
      ),

      home: const LoginScreen(), // 앱 시작 시 로그인 화면을 표시

    );
  }
}
