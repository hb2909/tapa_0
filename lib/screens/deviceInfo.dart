import 'package:flutter/material.dart';
import 'package:tapa_0/screens/warranty.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Profile Screen'),
//       ),
//     );
//   }
// }
// class DeviceScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Device Info'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Device Name:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text('Flood Detector X1000'), // Replace with desired name
//             SizedBox(height: 8.0),
//             Text(
//               'Battery Level:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text('N/A'), // Placeholder for dynamic data
//             SizedBox(height: 8.0),
//             Text(
//               'Wi-Fi Connection:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text('N/A'), // Placeholder for dynamic data
//             SizedBox(height: 8.0),
//             // Add more UI elements for other device info
//           ],
//         ),
//       ),
//     );
//   }
// }

class DeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Device'),
      ),
      body: Padding( // Add padding around all child widgets
        padding: const EdgeInsets.all(20.0), // Adjust padding as desired
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(16),
            child: Column( 
              children: [
                Image.asset(
                      'assets/images/connect.png', // Replace with your image path
                      height: 250.0, // Adjust image height as desired
                    ),
                SizedBox(height: 10.0),
                // Text(
                // 'Device Name:',
                // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // Text('TAPA-0 Flood Detection Device'),
                // SizedBox(height: 8.0),
                // Text(
                //   'Purchase Date:',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // Text('25 April 2024'),
                // SizedBox(height: 8.0),
                // Text(
                //   'Warranty Expiry:',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // Text('25 April 2025'),
                SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Device Name',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ), 
                        SizedBox(width: 30.0),
                        Text(':',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          'TAPA_0112030',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Purchase Date',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 1.0),
                        Text(':',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 15.0),
                        Text('11/12/2023',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Warranty Expiry',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(':',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 10.0),
                        Text('11/12/2025',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
            ),
          ),
        ),
        ]),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WarrantyScreen()),
            );
          },
          child: Text(
            'Check Warranty',
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
