import 'package:flutter/material.dart';
import 'package:tapa_0/screens/maintenance.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String _issueDescription = "";
  String _reportedBy = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Report an Issue'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Describe the Issue',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description of the issue.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _issueDescription = value!),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of the Issue',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide the date of the discovery of the issue.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _issueDescription = value!),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reported By (Name)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _reportedBy = value!),
              ),
              SizedBox(height: 16.0),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle form submission (send report)
                    print('Issue reported: $_issueDescription by $_reportedBy');
                  }
                },
                child: Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
