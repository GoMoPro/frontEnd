// lib/screen/find_passwd.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({Key? key}) : super(key: key);

  @override
  State<FindPasswordScreen> createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEmailSent = false;

  void resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _isEmailSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email has been sent")));
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to send reset email";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email";
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
        title: const Text("Find Password"),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/whale.png',
                  height: 150,
                ),
                const SizedBox(height: 20),
                if (!_isEmailSent) ...[
                  const Text(
                    'Enter your email to reset your password',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
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
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    CustomButton(
                      text: "Send Reset Email",
                      color: const Color(0xFF1976D2),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          resetPassword();
                        }
                      },
                    ),
                ] else ...[
                  const Text(
                    'Password reset email has been sent.\nPlease check your inbox.',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                CustomButton(
                  text: "Back to Login",
                  color: Colors.white,
                  textColor: Colors.black,
                  borderColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
