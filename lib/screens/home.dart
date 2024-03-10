import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  void activateESP32() {
    // Send a signal to Firebase to activate ESP32
    _databaseReference.child('activate_signal').set('activate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: Text('Home'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4), 
          child: Divider(
            color: Colors.blueGrey, 
            height: 4, 
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30), 
          Center( 
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Welcome to TAPA-0',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16), 
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 187, 205, 214), 
              borderRadius: BorderRadius.circular(10), 
            ),
            padding: EdgeInsets.all(16), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/connection.png',
                  height: 150, 
                  width: 150, 
                ),
                SizedBox(height: 10), 
                Text(
                  'Connect to TAPA-0',
                  style: TextStyle(fontSize: 18, color: Colors.black87), 
                ),
                SizedBox(height: 10), 
                ElevatedButton(
                  onPressed: activateESP32,
                  child: Text(
                    'Activate',
                    style: TextStyle(fontSize: 18), 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}