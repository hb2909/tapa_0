import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';


class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}
 
class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function 
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: Text('Profile'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4), 
          child: Divider(
            color: Colors.blueGrey, 
            height: 4, 
          ),
        ),
      ),
       
      //  floating Action Button using for signout , 
 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut();
        },
        child: Icon(Icons.logout_rounded),
        backgroundColor: Colors.blueGrey,
      ),
 
      body: Center(
        child: Text("User Screen"),
      ),
    );
  }
}