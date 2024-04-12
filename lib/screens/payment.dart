import 'package:flutter/material.dart';
import 'package:tapa_0/main.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/connection.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}


class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Payment'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _selectedPaymentMethod = 'ewallet'),
                  child: Text(
                    _selectedPaymentMethod == 'ewallet' ? 'E-Wallet (Selected)' : 'E-Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedPaymentMethod == 'ewallet' ? Colors.blue : Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(width: 8),
                Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _selectedPaymentMethod = 'card'),
                  child: Text(
                    _selectedPaymentMethod == 'card' ? 'Card (Selected)' : 'Card',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedPaymentMethod == 'ewallet' ? Colors.blue : Colors.blueGrey,
                  ),
                ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            if (_selectedPaymentMethod == 'ewallet')
              TextField(
                decoration: InputDecoration(
                  labelText: 'E-Wallet Number/Username',
                ),
              ),
            if (_selectedPaymentMethod == 'card')
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Expiry Date (MM/YY)',
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'CVV',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        //HomeScreen(),
                        //ConnectionScreen(),
                        MyBottomNavigationBar(),
                  ),
                );
              },
              child: Text(
                'Pay Now',
                style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    minimumSize: MaterialStateProperty.all(Size(150, 50)),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}