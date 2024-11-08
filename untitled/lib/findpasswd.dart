import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FindPasswordScreen extends StatefulWidget {
  @override
  _FindPasswordScreenState createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Color _borderColor = Colors.grey; // 기본 테두리 색상
  String _errorMessage = ''; // 에러 메시지 상태 변수
  bool _isEmailSent = false; // 이메일 전송 성공 여부

  // 이메일 유효성 검사 함수
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // 비밀번호 재설정 이메일 전송 함수
  void _sendPasswordResetEmail() async {
    String email = _emailController.text.trim(); // 공백 제거

    // 이메일 유효성 검사
    if (!isValidEmail(email)) {
      setState(() {
        _borderColor = Colors.red; // 이메일 형식이 유효하지 않으면 테두리를 빨간색으로 설정
        _errorMessage = '올바른 이메일 주소를 입력하세요.'; // 이메일 형식 오류 시 에러 메시지 설정
      });
      _hideErrorMessageAfterDelay(); // 2초 뒤에 에러 메시지 숨기기
      return; // 유효하지 않으면 함수 종료
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _borderColor = Colors.grey; // 성공하면 테두리를 다시 기본 색상으로 설정
        _errorMessage = ''; // 에러 메시지 초기화
        _isEmailSent = true; // 이메일 전송 성공 상태로 변경
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _borderColor = Colors.red; // 사용자가 없으면 테두리를 빨간색으로 설정
          _errorMessage = '회원 정보가 없습니다.'; // 에러 메시지 설정
        });
      } else {
        setState(() {
          _borderColor = Colors.red;
          _errorMessage = '회원 정보가 없습니다.'; // 기타 오류 메시지 설정
        });
      }
      _hideErrorMessageAfterDelay(); // 2초 뒤에 에러 메시지 숨기기
    }
  }

  // 에러 메시지를 일정 시간 후에 숨기는 함수 (2초 뒤)
  void _hideErrorMessageAfterDelay() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _errorMessage = ''; // 에러 메시지를 지움
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Find Password',
            style: TextStyle(color: Colors.white), // 상단바 글씨를 흰색으로 설정
          ),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false, // 왼쪽 상단의 뒤로가기 버튼 제거
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isEmailSent) ...[
              // 설명 텍스트 (이메일 입력 전)
              Text(
                'Enter your email here to reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // 이메일 입력 필드 (이메일 전송 전)
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'example@gmail.com', // 힌트 텍스트 추가
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: _borderColor), // 기본 상태의 테두리 색상 변경
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: _borderColor, width: 2.0), // 포커스 상태의 테두리 색상 변경
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),

              // Send E-mail 버튼 (이메일 전송 전)
              ElevatedButton(
                onPressed: _sendPasswordResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 배경색을 파란색으로 설정
                  minimumSize: Size(double.infinity, 50), // 버튼 크기 설정 (가로를 최대화)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child:
                Text('Send E-mail', style: TextStyle(color: Colors.white)),
              ),
            ] else ...[
              // 이메일 전송 후 표시할 텍스트 (성공 시)
              Text(
                '비밀번호 재설정 이메일이 전송되었습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],

            SizedBox(height: 10),

            if (!_isEmailSent) ...[
              // Back to Login 버튼 (이메일 입력 화면일 때만 표시)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 로그인 페이지로 돌아가기
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 배경색을 파란색으로 설정
                  minimumSize: Size(double.infinity, 50), // 버튼 크기 설정 (가로를 최대화)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child:
                Text('Back to Login', style: TextStyle(color: Colors.white)),
              ),
            ],

            SizedBox(height: 20),

            if (_errorMessage.isNotEmpty)
              Container(
                padding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                width:
                MediaQuery.of(context).size.width * 0.8,
                decoration:
                BoxDecoration(color:
                Colors.blue, borderRadius:
                BorderRadius.circular(20),
                    border:
                    Border.all(color:
                    Colors.blue, width:
                    2)),
                child:
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children:[
                    Icon(Icons.close,color:
                    Colors.red),
                    SizedBox(width:
                    8),
                    Text(_errorMessage, style:
                    TextStyle(color:
                    Colors.white)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}