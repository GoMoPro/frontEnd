import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Color _nicknameBorderColor = Colors.grey;
  Color _emailBorderColor = Colors.grey;
  Color _passwordBorderColor = Colors.grey;
  Color _confirmPasswordBorderColor = Colors.grey;

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  Future<void> _register() async {
    setState(() {
      _nicknameBorderColor = Colors.grey;
      _emailBorderColor = Colors.grey;
      _passwordBorderColor = Colors.grey;
      _confirmPasswordBorderColor = Colors.grey;
    });

    if (_formKey.currentState!.validate()) {
      // try {
      //   // 이메일 중복 확인
      //   final existingUser =
      //       await _auth.fetchSignInMethodsForEmail(_emailController.text);
      //   if (existingUser.isNotEmpty) {
      //     setState(() {
      //       _emailBorderColor = Colors.red;
      //     });
      //     _showErrorToast("이미 존재하는 이메일입니다.");
      //     return;
      //   }

      //   // 회원가입 진행
      //   final userCredential = await _auth.createUserWithEmailAndPassword(
      //     email: _emailController.text,
      //     password: _passwordController.text,
      //   );

      //   await userCredential.user!.updateDisplayName(_nicknameController.text);

      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("회원가입이 완료되었습니다!")),
      //   );

      //   Navigator.pop(context);
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'weak-password') {
      //     setState(() {
      //       _passwordBorderColor = Colors.red;
      //     });
      //     _showErrorToast("형식이 맞지 않습니다");
      //   } else if (e.code == 'email-already-in-use') {
      //     setState(() {
      //       _emailBorderColor = Colors.red;
      //     });
      //     _showErrorToast("이미 존재하는 이메일입니다.");
      //   }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: "Enter Nickname..",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _nicknameBorderColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _nicknameBorderColor = Colors.red;
                    });
                    _showErrorToast("존재하지 않는 이름입니다");
                    return '';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "example@gmail.com",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _emailBorderColor),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _emailBorderColor = Colors.red;
                    });
                    _showErrorToast("이미 존재하는 이메일입니다.");
                    return '';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    setState(() {
                      _emailBorderColor = Colors.red;
                    });
                    _showErrorToast("올바른 이메일 주소를 입력하세요");
                    return '';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _passwordBorderColor),
                  ),
                  helperText:
                      "At least 7 characters including English letters and numbers",
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null ||
                      value.length < 7 ||
                      !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{7,}$')
                          .hasMatch(value)) {
                    setState(() {
                      _passwordBorderColor = Colors.red;
                    });
                    _showErrorToast("형식이 맞지 않습니다");
                    return '';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: _confirmPasswordBorderColor),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    setState(() {
                      _passwordBorderColor = Colors.red;
                      _confirmPasswordBorderColor = Colors.red;
                    });
                    _showErrorToast("비밀번호 확인과 비밀번호가 일치하지 않습니다");
                    return '';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text("Sign Up"),
              ),
              ElevatedButton(
                onPressed: () {
                  // 로그인 페이지로 이동할 때의 로직
                },
                child: Text("Login"),
              ),
              SizedBox(height: 10),
              Text(
                "By clicking Create An Account, you agree to our Terms of Services.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
