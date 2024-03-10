import 'package:flutter/material.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Connection Screen'),
      ),
    );
  }
}