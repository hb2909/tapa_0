import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:provider/provider.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/welcome.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
    options: FirebaseOptions(
      appId: '1:1024857039444:android:065bac10c68c9f7d7183c1',
      apiKey: 'AIzaSyDcSgONVO8sNNT2dYcCVTnkkSE9KI_Dn_o',
      projectId: 'tapa0-75192',
      messagingSenderId: '1024857039444',
      databaseURL: 'https://tapa0-75192-default-rtdb.asia-southeast1.firebasedatabase.app', // Update with the correct database URL
    ),
 );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  //const MyApp({super.key});

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Onboarding(),
    );
  }
}


class Onboarding extends StatelessWidget {
  final List <Introduction> list = [
    Introduction(
      title: 'TAPA-0',
      subTitle: 'Your trusted Total Asset Protection device',
      imageUrl: 'assets/logo.png',
    ),
    Introduction(
      title: 'Flood Resistant',
      subTitle: 'Protect your cars from flood damage',
      imageUrl: 'assets/images/car_flood.png',
    ),
    Introduction(
      title: 'Protection',
      subTitle: 'Ensures your car is always protected in emergencies.',
      imageUrl: 'assets/images/protection.png',
    ),
    Introduction(
      title: 'Weather',
      subTitle: 'Check the current weather in your selected locations.',
      imageUrl: 'assets/images/weather.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Color.fromARGB(235, 249, 249, 249),
      foregroundColor: Color.fromARGB(255, 0, 55, 255),
      introductionList: list,
      onTapSkipButton: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          )),
      skipTextStyle: const TextStyle(
        color: Colors.blueGrey,
        fontSize: 18,
      ),
    );
  }
}


class MyBottomNavigationBar extends StatefulWidget{
  const MyBottomNavigationBar({Key? key}) : super(key: key);
  
   @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    WeatherScreen(),
    UserScreen(),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}