import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/passwordchange.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:tapa_0/screens/accountclosure.dart';
import 'package:tapa_0/screens/passwordchange.dart';
import 'package:tapa_0/screens/warranty.dart';

class UserScreen extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: Text('User'), 
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4), 
          child: Divider(
          color: Colors.blueGrey, 
          height: 4, 
        ),
      ),
    ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          ListTile(
            title: Text(
              'Profile',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to profile screen or handle profile actions
            },
          ),
          ListTile(
            title: Text(
              'Warranty',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WarrantyScreen()),
              );
              // Navigate to change password screen or handle password change
            },
          ),
          ListTile(
            title: Text(
              'Change Password',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordChangeScreen()),
              );
              // Navigate to change password screen or handle password change
            },
          ),
          ListTile(
            title: Text(
              'Account Closure',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to AccountClosureScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountClosureScreen()),
              );
            },
          ),
          // Add more list items as needed
        ],
      ),
      // Removed FloatingActionButton
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: ElevatedButton(
          onPressed: signOut,
          child: Text(
            'Log Out',
            style: TextStyle(
              color: Colors.white,
                fontSize: 20,
            ),),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text color
            backgroundColor: Colors.blueGrey, // Button background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}