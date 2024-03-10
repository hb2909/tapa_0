import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:tapa_0/screens/authopt.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login or Signup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}