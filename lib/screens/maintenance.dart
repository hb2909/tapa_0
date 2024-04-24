import 'package:flutter/material.dart';
import 'package:tapa_0/screens/report.dart';

class MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Maintenance'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Device Status Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 80.0),
                SizedBox(width: 16.0),
                Text(
                  'Operational',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            LinearProgressIndicator(
              value: 0.75, // Battery level (adjustable)
            ),
            SizedBox(height: 5.0),
            Text('Last Maintenance: 2024-04-24'),
            SizedBox(height: 20.0),

            // Maintenance Checklist Section
            Text(
              'Maintenance Checklist',
              style: TextStyle(fontSize: 18.0, fontWeight:FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Column(
              children: [
                MaintenanceTask(text: 'Inspect for visible damage'),
                MaintenanceTask(text: 'Test automatic deployment'),
                MaintenanceTask(text: 'Clean debris from sensors'),
              ],
            ),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) =>
            //             ReportScreen(),
            //       ),
            //     );
            //   },
            //   child: Text('Report Issue'),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportScreen()),
            );
          },
          child: Text(
            'Report an Issue',
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

class MaintenanceTask extends StatefulWidget {
  final String text;

  const MaintenanceTask({Key? key, required this.text}) : super(key: key);

  @override
  _MaintenanceTaskState createState() => _MaintenanceTaskState();
}

class _MaintenanceTaskState extends State<MaintenanceTask> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.text),
      value: isChecked,
      onChanged: (value) => setState(() => isChecked = value!),
    );
  }
}
