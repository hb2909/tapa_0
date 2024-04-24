import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tapa_0/screens/deviceInfo.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/faq.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:tapa_0/screens/accountclosure.dart';
import 'package:tapa_0/screens/faq.dart';
import 'package:tapa_0/screens/deviceInfo.dart';
import 'package:tapa_0/screens/warranty.dart';
import 'package:tapa_0/screens/maintenance.dart';


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
        title: Text('About Device'), 
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
              'Device Screen',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to profile screen or handle profile actions
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeviceScreen()),
              );
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
              'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQScreen()),
              );
              // Navigate to change password screen or handle password change
            },
          ),
          ListTile(
            title: Text(
              //'Account Closure',
              'Device Maintenance',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                //MaterialPageRoute(builder: (context) => AccountClosureScreen()),
                MaterialPageRoute(builder: (context) => MaintenanceScreen()),
              );
            },
          ),
          // Add more list items as needed
        ],
      ),
      // Removed FloatingActionButton
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: ElevatedButton(
          onPressed: signOut,
          child: Text(
            'Quit App',
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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
        ),
      ),
    );
  }
}