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
  // String deviceId = "";
  // String dataPath = "";
  // double waterLevel = 0.0;
  // bool esp32Activated = false;
  bool activate_signal = false;
  // //bool carPresence = false; // Added to store car presence state
  // bool carPresence = false; 
  String deviceId = "";
  String dataPath = "";
  double waterLevel = 0.0;
  bool esp32Activated = false;
  bool carPresence = false; // Updated to boolean
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
        // Cast the snapshot value to an int or handle potential null values
        waterLevel = (event.snapshot.value as int?)?.toDouble() ?? 0.0;
      });
    });
  }

  void _listenForCarPressure(String dataPath) {
    _databaseReference.child(dataPath).child('CarPresence').onValue.listen((event) {
      setState(() {
        carPresence = event.snapshot.value as bool? ?? false;
      });
    });
  }

void _listenForCoverState(String dataPath) {
    _databaseReference.child(dataPath).child('activate_signal').onValue.listen((event) {
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
      body: Padding(
         // Add padding around all child widgets
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
                // SizedBox(height: 10),
                // Text(
                //   'Car Presence: $carPresence',
                //   style: TextStyle(fontSize: 18),
                // ),
                SizedBox(height: 10),
                  Text(
                    'Car Presence: ${carPresence ? 'Yes' : 'No'}',
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
                esp32Activated ? 'Deactivate TAPA-0' : 'Activate TAPA-0',
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
