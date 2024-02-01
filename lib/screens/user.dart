import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('User Screen'),
      ),
      // bottomNavigationBar: NavigationBar(
      //   height: 80,
      //   selectedIndex: 0,

      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.person), label: 'User'),
      //     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      //     NavigationDestination(icon: Icon(Icons.cloud), label: 'Weather'),
      //   ],
      // ),
      // body: Container(),
    );
  }
}