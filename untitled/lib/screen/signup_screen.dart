import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void registration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Account already exists";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: const Color(0xFF1976D2),
        titleTextStyle: const TextStyle(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20), // 화면 상단과의 여백
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter Nickname",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your nickname';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10), // 여백 추가
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "example@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10), // 여백 추가
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 7) {
                      return 'Password must be at least 7 characters long';
                    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)')
                        .hasMatch(value)) {
                      return 'Password must include both letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10), // 여백 추가
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10), // 여백 추가
                const Text(
                  "At least 7 characters including English letters and numbers",
                  style: TextStyle(color: Color.fromARGB(255, 112, 112, 112)),
                ),
                const SizedBox(height: 5), // 여백 추가
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  CustomButton(
                    text: "Sign Up",
                    color: const Color(0xFF1976D2),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registration();
                      }
                    },
                  ),
                const SizedBox(height: 10), // 여백 추가
                CustomButton(
                  text: "Go to Login",
                  color: const Color(0xFF1976D2),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20), // 여백 추가
                const Text.rich(
                  TextSpan(
                    text: 'By clicking Sign up, you agree to our ',
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' of Service',
                      ),
                    ],
                  ),
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
