// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ActivateSignalListener extends StatefulWidget {
//   @override
//   _ActivateSignalListenerState createState() => _ActivateSignalListenerState();
// }

// class _ActivateSignalListenerState extends State<ActivateSignalListener> {
//   final databaseReference = FirebaseDatabase().reference();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   PermissionStatus notificationPermissionStatus = PermissionStatus.denied; // Initial assumption

//   @override
//   void initState() {
//     super.initState();
//     // Request permissions initially (consider adding a check for existing permission)
//     Permission.notification.request().then((status) {
//       setState(() {
//         notificationPermissionStatus = status;
//       });
//     });
//   }

//   Stream<bool?> listenForActivateSignal() {
//     return databaseReference
//         .child('Sensor/activate_signal')
//         .onValue
//         .map((event) => event.snapshot.value == true ? true : null);
//   }

//   Future<void> showNotification() async {
//     // Initialization (replace placeholders with your details)
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/app_icon');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // Notification details with TAPA-0 message
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('your_channel_id', 'your_channel_name',
//             importance: Importance.max, priority: Priority.high, ticker: 'ticker');
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//         0, 'TAPA-0 Activated!', 'Sensor activated!', platformChannelSpecifics);
//   }

//   Future<bool> checkAndRequestNotificationPermission() async {
//     final status = await Permission.notification.request();
//     if (status.isGranted) {
//       setState(() {
//         notificationPermissionStatus = status;
//       });
//       return true;
//     } else {
//       // Handle permission denied or permanently denied scenario (e.g., snackbar)
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<bool?>(
//       stream: listenForActivateSignal(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           // Handle error (e.g., Text('Error: ${snapshot.error}'))
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show loading indicator (e.g., CircularProgressIndicator())
//           return CircularProgressIndicator();
//         } else if (snapshot.hasData) {
//           final activateSignal = snapshot.data;
//           if (activateSignal != null) {
//             // Check permission and request if needed
//             checkAndRequestNotificationPermission().then((hasPermission) {
//               if (hasPermission) {
//                 showNotification();
//               }
//             });
//           }
//         }
//         return Container(); // Replace with your desired initial content
//       },
//     );
//   }
// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivateSignalListener extends StatefulWidget {
  ActivateSignalListener(String? token);

  @override
  _ActivateSignalListenerState createState() => _ActivateSignalListenerState();

  void listenForChanges() {}
}

class _ActivateSignalListenerState extends State<ActivateSignalListener> {
  final databaseReference = FirebaseDatabase().reference();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  PermissionStatus notificationPermissionStatus = PermissionStatus.denied; // Initial assumption

  @override
  void initState() {
    super.initState();
    // Request notification permission initially and handle denied/permanently denied scenarios
    _requestNotificationPermission();
    // Create the notification channel on app startup (consider adding error handling)
    _createNotificationChannel();
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    setState(() {
      notificationPermissionStatus = status;
    });
    if (status.isDenied) {
      // Inform user about permission denial (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification permission is denied. Please enable it in Settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      // Guide user to app settings for permission management (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification permission is permanently denied. You can enable it in Settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
  }

  Future<void> _createNotificationChannel() async {
    const String channelId = 'your_unique_channel_id'; // Replace with a unique identifier
    const String channelName = 'Your Channel Name'; // Replace with a descriptive name

    // Define Android notification details (separate from initialization)
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            channelId, channelName, importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    // Use AndroidNotificationDetails for notification details, not initialization
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: AndroidInitializationSettings('app_icon'))); // Replace with your app icon resource name
  }

  Stream<bool?> listenForActivateSignal() {
    return databaseReference
        .child('Sensor/activate_signal')
        .onValue
        .map((event) => event.snapshot.value == true ? true : null);
  }

  Future<void> showNotification() async {
    // Initialization with better defaults (consider customizing further)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Replace with your app icon resource name
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(); // Use DarwinInitializationSettings for iOS/macOS
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Notification details with TAPA-0 message (consider customizing)
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'TAPA-0 Activated!', 'Alert! TAPA-0 is activated!', platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
      stream: listenForActivateSignal(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Handle error (e.g., Text('Error: ${snapshot.error}'))
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator (e.g., CircularProgressIndicator())
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final activateSignal = snapshot.data;
          if (activateSignal != null) {
            // Check permission and request if needed (already handled in initState)
            if (notificationPermissionStatus.isGranted) {
              showNotification();
            }
          }
        }
        return Container(); // Replace with your desired initial content
      },
    );
  }
}
