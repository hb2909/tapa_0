import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tapa_0/main.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/payment.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:tapa_0/helper/firebase_auth.dart';
import 'package:tapa_0/helper/validator.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Welcome'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/logo.png'),
            ),
            Text(
              "Welcome!",
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 20),
            Text(
              "How will you be using this device today?",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Row(
              // Ensure buttons take up available space with `mainAxisSize`
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Device Owner",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    // Set a minimum width for consistent button size
                    minimumSize: MaterialStateProperty.all(Size(150, 50)),
                  ),
                ),
                SizedBox(width: 0), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentScreen()),
                    );
                  },
                  child: Text(
                    "Public",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    minimumSize: MaterialStateProperty.all(Size(150, 50)),
                  ),
                ),
              SizedBox(height: 10),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}