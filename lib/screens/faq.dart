//import 'package:flutter/material.dart';

// class FAQScreen extends StatelessWidget {
//   const FAQScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('FAQ Screen'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tapa_0/screens/warranty.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Frequently Asked Questions'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        centerTitle: true,
      ),
      body: 
          SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Is my information on TAPA-0 private?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'The TAPA-0 device will only record current data. All users’ information will be kept private and confidential. ',
            ),
            SizedBox(height: 16.0),
            Text(
              'How should I connect to the TAPA-0 device?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'The TAPA-0 device should be able to be connected by clicking the Start Scanning button on the Homepage.'
            ),
            SizedBox(height: 20.0),
            Text(
              'What should I do if my device is faulty?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you found out that your device is faulty or broken, please contact the device manufacturers at tapa0@gmail.com to schedule a maintenance service.',
            ),
            SizedBox(height: 20.0),
            Text(
              'What\'s Not Covered by the Warranty?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'The warranty does not cover damage caused by:\n'
              '\t\t\t• \t\tPhysical abuse or neglect.\n'
              '\t\t\t• \t\tImproper installation or use.\n'
              // '\t\t\t• \t\tNatural Disasters (e.g., lightning strike, landslides)\n',
              '\t\t\t• \t\tIntentional damage to the device. \n',
            ),
            SizedBox(height: 20.0),
            Text(
              'What if my questions are not found in the FAQ page?',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If your questions are not included in our FAQ page, feel free to email us at support@tapa0.com and we will try our best to answer your questions and problems. ',
            ),
          ],
        ),
      ),
    );
  }
}