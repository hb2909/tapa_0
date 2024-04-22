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
        title: Text('Frequently Asked Questions'),
      ),
      body: 
          SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coverage',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'This warranty covers TAPA-0 hardware device and its accompanying products and sensors.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Warranty Period',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'The warranty is valid for one (1) year from the date of purchase.',
            ),
            SizedBox(height: 16.0),
            Text(
              'What\'s Covered',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'This warranty covers device manufacturing defects and any malfunctions in its material and workmanship.',
            ),
            SizedBox(height: 16.0),
            Text(
              'What\'s Not Covered',
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
            SizedBox(height: 16.0),
            Text(
              'Warranty Service Process',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'To make a warranty claim, please contact us at support@tapa0.com.',
            ),
          ],
        ),
      ),
    );
  }
}