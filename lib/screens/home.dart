// 

// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;

//   Future<void> scanQRCode() async {
//     try {
//       final scanResult = await QRCodeScannerPlatform.instance.scanQRCode();
//       if (scanResult != null) {
//         final jsonData = jsonDecode(scanResult.code);
//         deviceId = jsonData['device_id'];
//         dataPath = jsonData['data_path'];
//         _listenForWaterLevel(dataPath);
//       }
//     } catch (e) {
//       print("Error scanning QR code: $e");
//     }
//   }

//   void _listenForWaterLevel(String dataPath) {
//   _databaseReference.child(dataPath).onValue.listen((event) {
//     setState(() {
//       waterLevel = (event.snapshot.value as double?) ?? 0.0;
//     });
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Welcome to TAPA-0',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 30),
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 187, 205, 214),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/connection.png',
//                     height: 150,
//                     width: 150,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Connect to TAPA-0',
//                     style: TextStyle(fontSize: 18, color: Colors.black87),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: scanQRCode,
//                     child: Text(
//                       'Scan QR Code',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Water Level: $waterLevel',
//               style: TextStyle(fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false;

//   Future<void> _startScanning() async {
//   var status = await Permission.camera.status;
//   if (!status.isGranted) {
//     status = await Permission.camera.request();
//     if (!status.isGranted) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Permission Required'),
//             content: Text('Please grant camera permission to scan QR codes.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//   }

//   try {
//     final controller = qrScannerKey.currentState as QRViewController;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         final jsonData = jsonDecode(scanData.code ?? '');
//         deviceId = jsonData['device_id'];
//         dataPath = jsonData['data_path'];
//         // Set Flutter app to the device path
//         _databaseReference.child('device_path').set(dataPath);
//         // Send activate signal to the device
//         _databaseReference.child(dataPath).set('activate');
//         // Listen for water level updates
//         _listenForWaterLevel(dataPath);
//       } catch (e) {
//         print("Error parsing QR code data: $e");
//       }
//     });
//     controller.resumeCamera();
//   } catch (e) {
//     print("Error starting QR scanner: $e");
//   }
// }


//   void _listenForWaterLevel(String dataPath) {
//     _databaseReference.child(dataPath).onValue.listen((event) {
//       setState(() {
//         waterLevel = (event.snapshot.value as double?) ?? 0.0;
//       });
//     });
//   }

//   void _listenForESP32Activation() {
//     _databaseReference.child('ESP32').onValue.listen((event) {
//       setState(() {
//         esp32Activated = event.snapshot.value == 'activate';
//       });
//     });
//   }

//   void _toggleESP32Activation() {
//     if (esp32Activated) {
//       _databaseReference.child('ESP32').set('deactivate');
//     } else {
//       _databaseReference.child('ESP32').set('activate');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Welcome to TAPA-0',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 187, 205, 214),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/connection.png',
//                   height: 150,
//                   width: 150,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Connect to TAPA-0',
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _startScanning,
//                   child: Text(
//                     'Scan QR Code',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false;
//   QRViewController? controller;

//   Future<void> _startScanning() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Permission Required'),
//               content: Text('Please grant camera permission to scan QR codes.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     }

//     try {
//       final controller = qrScannerKey.currentState as QRViewController;
//       controller.scannedDataStream.listen((scanData) {
//         print('Scanned data: ${scanData.code}');
//         try {
//           final jsonData = jsonDecode(scanData.code ?? '');
//           deviceId = jsonData['device_id'];
//           dataPath = jsonData['data_path'];

//           // Optional: Validate data before setting
//           if (deviceId.isEmpty || dataPath.isEmpty) {
//             throw Exception("Missing data in QR code");
//           }

//           // Set data in database (existing code)
//           _databaseReference.child('device_path').set(dataPath);
//           _databaseReference.child(dataPath).set('activate');
//           _listenForWaterLevel(dataPath);

//         } catch (e) {
//           print("Error parsing QR code data: $e");
//           // Optionally display an error message to the user (e.g., with SnackBar)
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text("Error parsing QR code")));
//         }
//       });
//       controller.resumeCamera();
//     } catch (e) {
//       print("Error starting QR scanner: $e");
//     }
//   }

//   void _listenForWaterLevel(String dataPath) {
//     _databaseReference.child(dataPath).onValue.listen((event) {
//       setState(() {
//         waterLevel = (event.snapshot.value as double?) ?? 0.0;
//       });
//     });
//   }

//   void _listenForESP32Activation() {
//     _databaseReference.child('ESP32').onValue.listen((event) {
//       setState(() {
//         esp32Activated = event.snapshot.value == 'activate';
//       });
//     });
//   }

//   void _toggleESP32Activation() {
//     if (esp32Activated) {
//       _databaseReference.child('ESP32').set('deactivate');
//     } else {
//       _databaseReference.child('ESP32').set('activate');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _listenForESP32Activation(); // Call to listen for ESP32 activation on startup
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Welcome to TAPA-0',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Expanded( // Wrap QRView and button in an Expanded widget
//             child: Stack( // Stack allows positioning elements on top of each other
//               alignment: Alignment.center, // Center content within the Stack
//               children: [
//                 QRView(
//                   key: qrScannerKey,
//                   onQRViewCreated: _onQRViewCreated, // Function to handle QRView creation
//                 ),
//                 Positioned( // Position button below the QRView
//                   bottom: 10,
//                   child: ElevatedButton(
//                     onPressed: _startScanning,
//                     child: Text(
//                       'Scan QR Code',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }


//   void _onQRViewCreated(QRViewController controller) {
//   setState(() {
//     this.controller = controller;
//   });
//   }
// }



// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false;
//   late QRViewController controller; // Added

//   @override
//   void dispose() {
//     controller.dispose(); // Added to dispose the QRViewController
//     super.dispose();
//   }

//   Future<void> _startScanning() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Permission Required'),
//               content: Text('Please grant camera permission to scan QR codes.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     }

//     try {
//       final currentState = qrScannerKey.currentState;
//       if (currentState != null) {
//         final controller = currentState as QRViewController;
//         controller.scannedDataStream.listen((scanData) {
//           print('Scanned data: ${scanData.code}');
//           try {
//             final jsonData = jsonDecode(scanData.code ?? '');
//             deviceId = jsonData['device_id'];
//             dataPath = jsonData['data_path'];
//             // Set Flutter app to the device path
//             _databaseReference.child('device_path').set(dataPath);
//             // Send activate signal to the device
//             _databaseReference.child(dataPath).set('activate');
//             // Listen for water level updates
//             _listenForWaterLevel(dataPath);
//           } catch (e) {
//             print("Error parsing QR code data: $e");
//           }
//         });
//         controller.resumeCamera();
//       } else {
//         print('QR Scanner key currentState is null.');
//       }
//     } catch (e) {
//       print("Error starting QR scanner: $e");
//     }
//   }

//   void _listenForWaterLevel(String dataPath) {
//     _databaseReference.child(dataPath).onValue.listen((event) {
//       setState(() {
//         waterLevel = (event.snapshot.value as double?) ?? 0.0;
//       });
//     });
//   }

//   void _listenForESP32Activation() {
//     _databaseReference.child('ESP32').onValue.listen((event) {
//       setState(() {
//         esp32Activated = event.snapshot.value == 'activate';
//       });
//     });
//   }

//   void _toggleESP32Activation() {
//     if (esp32Activated) {
//       _databaseReference.child('ESP32').set('deactivate');
//     } else {
//       _databaseReference.child('ESP32').set('activate');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Welcome to TAPA-0',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 187, 205, 214),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 200, // Adjust the height as needed
//                   width: 200, // Adjust the width as needed
//                   child: QRView(
//                     key: qrScannerKey,
//                     onQRViewCreated: _onQRViewCreated,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Point the camera towards the QR code',
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _startScanning,
//                   child: Text(
//                     'Start Scanning',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         final jsonData = jsonDecode(scanData.code ?? '');
//         deviceId = jsonData['device_id'];
//         dataPath = jsonData['data_path'];
//         // Set Flutter app to the device path
//         _databaseReference.child('device_path').set(dataPath);
//         // Send activate signal to the device
//         _databaseReference.child(dataPath).set('activate');
//         // Listen for water level updates
//         _listenForWaterLevel(dataPath);
//       } catch (e) {
//         print("Error parsing QR code data: $e");
//       }
//     });
//   }
// }

// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false;
//   late QRViewController controller; // Added

//   @override
//   void dispose() {
//     controller?.dispose(); // Added to dispose the QRViewController
//     super.dispose();
//   }

//   Future<void> _startScanning() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Permission Required'),
//               content: Text('Please grant camera permission to scan QR codes.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     }

//     try {
//     final controller = qrScannerKey.currentState as QRViewController;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         // Extract base path and sensor name placeholder from QR code data
//         final pattern = RegExp(r"SET_DATAPATH:(.*)/(.*)/Sensor");
//         final match = pattern.firstMatch(scanData.code ?? '');
//         if (match != null) {
//           final basePath = match.group(1) ?? '';
//           final sensorName = match.group(2) ?? '';

//           // Construct data path without sending to database
//           final dataPath = basePath.replaceAll('{SENSOR_NAME}', sensorName);

//           // Listen for water level and CoverState updates on the constructed dataPath
//           _listenForWaterLevel(dataPath);
//           _listenForCoverState(dataPath);
//         } else {
//           print("Invalid QR code format");
//           // Handle invalid QR code format (e.g., display error message)
//         }
//       } catch (e) {
//         print("Error parsing QR code data: $e");
//         // Handle parsing errors (e.g., display error message)
//       }
//     });
//     controller.resumeCamera();
//   } catch (e) {
//     print("Error starting QR scanner: $e");
//   }
// }

//   void _listenForWaterLevel(String dataPath) {
//     _databaseReference.child(dataPath).child('wval').onValue.listen((event) {
//       setState(() {
//         waterLevel = (event.snapshot.value as double?) ?? 0.0;
//       });
//     });
//   }

//   void _listenForCoverState(String dataPath) {
//     _databaseReference.child(dataPath).child('CoverState').onValue.listen((event) {
//       setState(() {
//         esp32Activated = event.snapshot.value == 'true'; // Assuming CoverState is a string representing true/false
//       });
//     });
//   }

//   void _toggleESP32Activation() {
//     if (esp32Activated) {
//       _databaseReference.child('dataPath').child('CoverState').set('deactivate');
//     } else {
//       _databaseReference.child('dataPath').child('CoverState').set('activate');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Welcome to TAPA-0',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 187, 205, 214),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 200, // Adjust the height as needed
//                   width: 200, // Adjust the width as needed
//                   child: QRView(
//                     key: qrScannerKey,
//                     onQRViewCreated: _onQRViewCreated,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Point the camera towards the QR code',
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10),
//                 // ElevatedButton(
//                 //   onPressed: _startScanning,
//                 //   child: Text(
//                 //     'Start Scanning',
//                 //     style: TextStyle(fontSize: 18),
//                 //   ),
//                 // ),
//                 ElevatedButton(
//                   onPressed: _startScanning, // Call _startScanning on button press
//                   child: Text('Start Scanning',
//                   style: TextStyle(fontSize: 18,),
//                 ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         final scannedData = scanData.code;
//         if (scannedData != null) { // Add null check
//           setState(() {
//             dataPath = scannedData;
//           });
//           print('Scanned data path: $dataPath');
//           // Set Flutter app to the device path
//           _databaseReference.child('device_path').set(dataPath);
//           // Send activate signal to the device
//           _databaseReference.child(dataPath).set('activate');
//           // Listen for water level updates
//           _listenForWaterLevel(dataPath);
//         } else {
//           print('Scanned data is null.');
//         }
//       } catch (e) {
//         print("Error handling scanned data: $e");
//       }
//     });
//   }
// }



// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false;
//   late QRViewController controller; // Added

//   @override
//   void dispose() {
//     controller?.dispose(); // Added to dispose the QRViewController
//     super.dispose();
//   }

//   Future<void> _startScanning() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Permission Required'),
//               content: Text('Please grant camera permission to scan QR codes.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     }

//     try {
//       final controller = qrScannerKey.currentState as QRViewController;
//       controller.scannedDataStream.listen((scanData) {
//         print('Scanned data: ${scanData.code}');
//         try {
//           final scannedData = scanData.code;
//           if (scannedData != null) { // Add null check
//             setState(() {
//               dataPath = scannedData;
//             });
//             print('Scanned data path: $dataPath');
//             // Listen for water level and CoverState updates on the dataPath
//             _listenForWaterLevel(dataPath);
//             _listenForCoverState(dataPath);
//           } else {
//             print('Scanned data is null.');
//           }
//         } catch (e) {
//           print("Error handling scanned data: $e");
//         }
//       });
//       controller.resumeCamera();
//     } catch (e) {
//       print("Error starting QR scanner: $e");
//     }
//   }

//   void _listenForWaterLevel(String dataPath) {
//     _databaseReference.child(dataPath).child('wval').onValue.listen((event) {
//       setState(() {
//         waterLevel = (event.snapshot.value as double?) ?? 0.0;
//       });
//     });
//   }

//   void _listenForCoverState(String dataPath) {
//     _databaseReference.child(dataPath).child('CoverState').onValue.listen((event) {
//       setState(() {
//         esp32Activated = event.snapshot.value == 'true'; // Assuming CoverState is a string representing true/false
//       });
//     });
//   }

//   void _toggleESP32Activation() {
//     if (esp32Activated) {
//       _databaseReference.child(dataPath).child('CoverState').set(false);
//     } else {
//       _databaseReference.child(dataPath).child('CoverState').set(true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Welcome to TAPA-0',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//                     Container(
//             margin: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 187, 205, 214),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 200, // Adjust the height as needed
//                   width: 200, // Adjust the width as needed
//                   child: QRView(
//                     key: qrScannerKey,
//                     onQRViewCreated: _onQRViewCreated,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Point the camera towards the QR code',
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _startScanning,
//                   child: Text(
//                     'Start Scanning',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         final scannedData = scanData.code;
//         if (scanData != null) { // Add null check
//           setState(() {
//             if (scannedData != null) {
//               dataPath = scannedData;
//             } else {
//               print('Scanned data is null');
//             }
//           });
//           print('Scanned data path: $dataPath');
//           // Listen for water level and CoverState updates on the dataPath
//           _listenForWaterLevel(dataPath);
//           _listenForCoverState(dataPath);
//         } else {
//           print('Scanned data is null.');
//         }
//       } catch (e) {
//         print("Error handling scanned data: $e");
//       }
//     });
//   }
// }



// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false; // Now a boolean value
//   late QRViewController controller; // Added

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   Future<void> _startScanning() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Permission Required'),
//               content: Text('Please grant camera permission to scan QR codes.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     }

//     try {
//       final controller = qrScannerKey.currentState as QRViewController;
//       controller.scannedDataStream.listen((scanData) {
//         print('Scanned data: ${scanData.code}');
//         try {
//           final scannedData = scanData.code;
//           if (scanData != null) { // Add null check
//           setState(() {
//             if (scannedData != null) {
//               dataPath = scannedData;
//             } else {
//               print('Scanned data is null');
//             }
//           });
//             print('Scanned data path: $dataPath');
//             // Listen for water level and CoverState updates on the dataPath
//             _listenForWaterLevel(dataPath);
//             _listenForCoverState(dataPath);
//             // Show successful scan pop up with dataPath
//             _showScanSuccessPopup(dataPath);
//           } else {
//             print('Scanned data is null.');
//           }
//         } catch (e) {
//           print("Error handling scanned data: $e");
//         }
//       });
//       controller.resumeCamera();
//     } catch (e) {
//       print("Error starting QR scanner: $e");
//     }
//   }

//   void _listenForWaterLevel(String dataPath) {
//     _databaseReference.child(dataPath).child('wval').onValue.listen((event) {
//       setState(() {
//         waterLevel = (event.snapshot.value as double?) ?? 0.0;
//       });
//     });
//   }

//   void _listenForCoverState(String dataPath) {
//     _databaseReference.child(dataPath).child('CoverState').onValue.listen((event) {
//       setState(() {
//         esp32Activated = event.snapshot.value as bool; // Cast to bool
//       });
//     });
//   }

//   void _toggleESP32Activation() {
//     setState(() {
//       esp32Activated = !esp32Activated;
//       _databaseReference.child(dataPath).child('CoverState').set(esp32Activated);
//     });
//   }

//   void _showScanSuccessPopup(String dataPath) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Scan Successful!'),
//           content: Text('Data Path: $dataPath'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
          
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 187, 205, 214),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 200, // Adjust the height as needed
//                   width: 200, // Adjust the width as needed
//                   child: QRView(
//                     key: qrScannerKey,
//                     onQRViewCreated: _onQRViewCreated,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Point the camera towards the QR code',
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _startScanning,
//                   child: Text(
//                     'Start Scanning',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         final scannedData = scanData.code;
//         if (scanData != null) { // Add null check
//           setState(() {
//             dataPath = scannedData!;
//           });
//           print('Scanned data path: $dataPath');
//           // Listen for water level and CoverState updates on the dataPath
//           _listenForWaterLevel(dataPath);
//           _listenForCoverState(dataPath);
//           // Show successful scan pop up with dataPath
//           _showScanSuccessPopup(dataPath);
//         } else {
//           print('Scanned data is null.');
//         }
//       } catch (e) {
//         print("Error handling scanned data: $e");
//       }
//     });
//   }
// }



// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false; // Now a boolean value
//   String carPresence = ""; // Added to store car presence state
//   late QRViewController controller; // Added null-safety

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   Future<void> _startScanning() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Permission Required'),
//               content: Text('Please grant camera permission to scan QR codes.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     }

//     try {
//       controller = qrScannerKey.currentState as QRViewController;
//       controller.scannedDataStream.listen((scanData) {
//         print('Scanned data: ${scanData.code}');
//         try {
//           final scannedData = scanData.code;
//           if (scanData != null) { // Add null check
//             setState(() {
//               dataPath = scannedData!;
//             });
//             print('Scanned data path: $dataPath');
//             // Listen for water level and CoverState updates on the dataPath
//             _listenForWaterLevel(dataPath);
//             _listenForCoverState(dataPath);
//             // Show successful scan pop up with dataPath
//             //_showScanSuccessPopup(dataPath);
//           } else {
//             print('Scanned data is null.');
//           }
//         } catch (e) {
//           print("Error handling scanned data: $e");
//         }
//       });
//       controller.resumeCamera();
//     } catch (e) {
//       print("Error starting QR scanner: $e");
//     }
//   }

//   void _listenForWaterLevel(String dataPath) {
//     _databaseReference.child(dataPath).child('Wval').onValue.listen((event) {
//       setState(() {
//         waterLevel = (event.snapshot.value as double?) ?? 0.0;
//         carPresence = waterLevel > 0.0 ? 'Car on TAPA-0' : 'No Car on TAPA-0';
//       });
//     });
//   }

//   void _listenForCoverState(String dataPath) {
//     _databaseReference.child(dataPath).child('CoverState').onValue.listen((event) {
//       setState(() {
//         esp32Activated = event.snapshot.value as bool; // Cast to bool
//       });
//     });
//   }

//   void _toggleESP32Activation() {
//     setState(() {
//       esp32Activated = !esp32Activated;
//       _databaseReference.child(dataPath).child('CoverState').set(esp32Activated);
//     });
//   }

//   void _showScanSuccessPopup(String dataPath) {
//   showDialog(
//     context: context, // Use the context passed to build
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Scan Successful!'),
//         content: Text('Data Path: $dataPath'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context), // Use the context from builder
//             child: Text('OK'),
            
//           ),
//         ],
//       );
//     },
//   );
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 187, 205, 214),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 200, // Adjust the height as needed
//                   width: 200, // Adjust the width as needed
//                   child: QRView(
//                     key: qrScannerKey,
//                     onQRViewCreated: _onQRViewCreated,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Point the camera towards the QR code',
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _startScanning,
//                   child: Text(
//                     'Start Scanning',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           // Display car presence text
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 carPresence, // Display car presence state
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           // Display CoverState text
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Cover State: ${esp32Activated ? 'Active' : 'Inactive'}',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         final scannedData = scanData.code;
//         if (scanData != null) { // Add null check
//           setState(() {
//             dataPath = scannedData!;
//           });
//           print('Scanned data path: $dataPath');
//           // Listen for water level and CoverState updates on the dataPath
//           _listenForWaterLevel(dataPath);
//           _listenForCoverState(dataPath);
//           // Show successful scan pop up with dataPath
//           //_showScanSuccessPopup(dataPath);
//         } else {
//           print('Scanned data is null.');
//         }
//       } catch (e) {
//         print("Error handling scanned data: $e");
//       }
//     });
//   }
// }




// import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
//   String deviceId = "";
//   String dataPath = "";
//   double waterLevel = 0.0;
//   bool esp32Activated = false; // Now a boolean value
//   String carPresence = ""; // Added to store car presence state
//   late QRViewController controller; // Added null-safety

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   Future<void> _startScanning() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         // Handle permission denial (optional)
//         return;
//       }
//     }

//     try {
//       controller = qrScannerKey.currentState as QRViewController;
//       controller.scannedDataStream.listen((scanData) {
//         print('Scanned data: ${scanData.code}');
//         try {
//           final scannedData = scanData.code;
//           if (scanData != null) { // Add null check
//             setState(() {
//               dataPath = scannedData!;
//             });
//             print('Scanned data path: $dataPath');
//             // Listen for water level and CoverState updates on the dataPath
//             _listenForWaterLevel(dataPath);
//             _listenForCoverState(dataPath);
//           } else {
//             print('Scanned data is null.');
//           }
//         } catch (e) {
//           print("Error handling scanned data: $e");
//         }
//       });
//       controller.resumeCamera();
//     } catch (e) {
//       print("Error starting QR scanner: $e");
//     }
//   }

//   void _listenForWaterLevel(String dataPath) {
//   _databaseReference.child(dataPath).child('Wval').onValue.listen((event) {
//     setState(() {
//       waterLevel = (event.snapshot.value as double?) ?? 0.0;
//     });
//   });
// }

// void _listenForCarPressure(String dataPath) {
//   _databaseReference.child(dataPath).child('CarPressure').onValue.listen((event) {
//     setState(() {
//       final carPressure = (event.snapshot.value as double?) ?? 0.0;
//       carPresence = carPressure > 0.0 ? 'Car on TAPA-0' : 'No Car on TAPA-0';
//     });
//   });
// }

// void _listenForCoverState(String dataPath) {
//   _databaseReference.child(dataPath).child('CoverState').onValue.listen((event) {
//     setState(() {
//       esp32Activated = event.snapshot.value as bool;
//     });
//   });
// }

//   void _toggleESP32Activation() {
//     setState(() {
//       esp32Activated = !esp32Activated;
//       _databaseReference.child(dataPath).child('CoverState').set(esp32Activated);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text('Home'),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4),
//           child: Divider(
//             color: Colors.blueGrey,
//             height: 4,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 30),
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 187, 205, 214),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 200, // Adjust the height as needed
//                   width: 200, // Adjust the width as needed
//                   child: QRView(
//                     key: qrScannerKey,
//                     onQRViewCreated: _onQRViewCreated,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Point the camera towards the QR code',
//                   style: TextStyle(fontSize: 18, color: Colors.black87),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _startScanning,
//                   child: Text(
//                     'Start Scanning',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Water Level: $waterLevel',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           // Display car presence text
//           // Center(
//           //   child: Padding(
//           //     padding: EdgeInsets.symmetric(horizontal: 16),
//           //     child: Text(
//           //       carPresence, // Display car presence state
//           //       style: TextStyle(fontSize: 18),
//           //     ),
//           //   ),
//           // ),
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: carPresence > 0.0
//                   ? Text(
//                       'Car on TAPA-0',
//                       style: TextStyle(fontSize: 18),
//                     )
//                   : Text(
//                       'No Car on TAPA-0',
//                       style: TextStyle(fontSize: 18),
//                     ),
//             ),
//           ),
//           SizedBox(height: 10),
//           // Display CoverState text
//           Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Cover State: ${esp32Activated ? 'Active' : 'Inactive'}',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             child: ElevatedButton(
//               onPressed: _toggleESP32Activation,
//               child: Text(
//                 esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       print('Scanned data: ${scanData.code}');
//       try {
//         final scannedData = scanData.code;
//         if (scanData != null) { // Add null check
//           setState(() {
//             dataPath = scannedData!;
//           });
//           print('Scanned data path: $dataPath');
//           // Listen for water level and CoverState updates on the dataPath
//             _listenForWaterLevel(dataPath);
//             _listenForCarPressure(dataPath);
//             _listenForCoverState(dataPath);
//         } else {
//           print('Scanned data is null.');
//         }
//       } catch (e) {
//         print("Error handling scanned data: $e");
//       }
//     });
//   }
// }

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey qrScannerKey = GlobalKey(debugLabel: 'QR');
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String deviceId = "";
  String dataPath = "";
  double waterLevel = 0.0;
  bool esp32Activated = false;
  String carPresence = ""; // Added to store car presence state
  late QRViewController controller; // Added null-safety

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        // Handle permission denial (optional)
        return;
      }
    }

    try {
      controller = qrScannerKey.currentState as QRViewController;
      controller.scannedDataStream.listen((scanData) {
        print('Scanned data: ${scanData.code}');
        if (scanData != null) { // Add null check
          setState(() {
            dataPath = scanData.code!;
            // Call functions to listen for data points only after successful scan
            _listenForWaterLevel(dataPath);
            _listenForCarPressure(dataPath);
            _listenForCoverState(dataPath);
          });
          print('Scanned data path: $dataPath');
        } else {
          print('Scanned data is null.');
        }
      });
      controller.resumeCamera();
    } catch (e) {
      print("Error starting QR scanner: $e");
    }
  }

  void _listenForWaterLevel(String dataPath) {
    _databaseReference.child(dataPath).child('Wval').onValue.listen((event) {
      setState(() {
        waterLevel = (event.snapshot.value as double?) ?? 0.0;
      });
    });
  }

  void _listenForCarPressure(String dataPath) {
    _databaseReference.child(dataPath).child('CarPressure').onValue.listen((event) {
      setState(() {
        final carPressure = (event.snapshot.value as double?) ?? 0.0;
        carPresence = carPressure > 0.0 ? 'Yes' : 'No';
      });
    });
  }

  void _listenForCoverState(String dataPath) {
    _databaseReference.child(dataPath).child('CoverState').onValue.listen((event) {
      setState(() {
        esp32Activated = event.snapshot.value as bool;
      });
    });
  }

  void _toggleESP32Activation() {
    setState(() {
      esp32Activated = !esp32Activated;
      _databaseReference.child(dataPath).child('CoverState').set(esp32Activated);
    });
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
      body: Padding( // Add padding around all child widgets
        padding: const EdgeInsets.all(20.0), // Adjust padding as desired
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          Expanded( 
            // Make the QR view take up available space
            child: AspectRatio( // Ensure a square aspect ratio
              aspectRatio: 1,
              child: QRView(
                key: qrScannerKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center( 
            child: 
              Text(
                'Point the camera towards the QR code',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _startScanning,
              child: Text(
                'Start Scanning',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: _startScanning,
          //   child: Text(
          //     'Start Scanning',
          //     style: TextStyle(fontSize: 18),
          //   ),
          // ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 187, 205, 214),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(16),
            child: Column( // Nested column for better layout
              children: [
                Text(
                  'Water Level: $waterLevel',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Car Presence: $carPresence',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'TAPA-0: ${esp32Activated ? 'Active' : 'Inactive'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _toggleESP32Activation,
              child: Text(
                esp32Activated ? 'Deactivate ESP32' : 'Activate ESP32',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print('Scanned data: ${scanData.code}');
      try {
        final scannedData = scanData.code;
        if (scanData != null) { // Add null check
          setState(() {
            dataPath = scannedData!;
          });
          print('Scanned data path: $dataPath');
          // Listen for water level and CoverState updates on the dataPath
            _listenForWaterLevel(dataPath);
            _listenForCarPressure(dataPath);
            _listenForCoverState(dataPath);
        } else {
          print('Scanned data is null.');
        }
      } catch (e) {
        print("Error handling scanned data: $e");
      }
    });
  }
}