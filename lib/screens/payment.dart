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
import 'package:flutter/foundation.dart'; 

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card'; // Default selection
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';
  String _eWallet = '';
  String _pin = '';

  bool _validateCardNumber(String cardNumber) {
    return cardNumber.length >= 16; 
  }

  bool _validateExpiryDate(String expiryDate) {
    if (expiryDate.length != 5) {
      return false;
    }
    int? month = int.tryParse(expiryDate.substring(0, 2));
    int? year = int.tryParse(expiryDate.substring(3));
    if (month == null || year == null) {
      return false;
    }
    return month >= 1 && month <= 12 && year! + 2000 > DateTime.now().year;
  }

  bool _validateCvv(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4;
  }

  bool _validateEWallet(String eWallet) {
  return eWallet.length == 10; // Only valid if 10 digits
}
  
  bool _validatePin(String pin) {
    return pin.length == 6; 
  }

  bool _validateForm() {
    if (_selectedPaymentMethod == 'card') {
      if (!_validateCardNumber(_cardNumber)) {
        return false;
      }
      if (!_validateExpiryDate(_expiryDate)) {
        return false;
      }
    }
    else if (_selectedPaymentMethod == 'ewallet') {
      if (!_validateEWallet(_eWallet)) {
        return false;
      }
      if (!_validatePin(_pin)) {
        return false;
      }
    }
    return true;
  }

  void _handlePayNow() {
    if (_validateForm()) {
      // User input is valid, navigate to Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fix the highlighted errors before proceeding.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: Flexible( 
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedPaymentMethod = 'ewallet'),
                    child: Text(
                      _selectedPaymentMethod == 'ewallet' ? 'E-Wallet (Selected)' : 'E-Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPaymentMethod == 'ewallet' ? Colors.blue : Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _selectedPaymentMethod = 'card'),
                    child: Text(
                      _selectedPaymentMethod == 'card' ? 'Card (Selected)' : 'Card',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPaymentMethod == 'ewallet' ? Colors.blue : Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedPaymentMethod == 'card'
                  ? Image.asset(
                      'assets/images/card_icon.png',
                      width: 200, 
                      height: 150, 
                      fit: BoxFit.contain, 
                    )
                  : Image.asset(
                      'assets/images/ewallet_icon.png',
                      width: 200, 
                      height: 150, 
                      fit: BoxFit.cover, 
                    ),
                ],
            ),
            SizedBox(height: 10.0),
            if (_selectedPaymentMethod == 'ewallet')
            Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'E-Wallet',
                  errorText: _validateEWallet(_eWallet) ? null : 'Enter your phone number',
                ),
                onChanged: (value) => setState(() => _eWallet = value),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'PIN Number',
                  errorText: _validatePin(_pin) ? null : 'Enter a valid PIN (6 digits)',
                ),
                onChanged: (value) => setState(() => _pin = value),
              ),
            ],
            ),
            if (_selectedPaymentMethod == 'card')
            Column(
            children: [
              TextField(
                keyboardType: TextInputType.number, // For card number
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  errorText: _validateCardNumber(_cardNumber) ? null : 'Invalid card number (16 digits)',
                ),
                onChanged: (value) => setState(() => _cardNumber = value),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number, // For expiry date
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        errorText: _validateExpiryDate(_expiryDate) ? null : 'Invalid expiry date (MM/YY)',
                      ),
                      onChanged: (value) => setState(() => _expiryDate = value),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number, // For CVV
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        errorText: _validateCvv(_cvv) ? null : 'Invalid CVV (3-4 digits)',
                        counterText: _cvv.length.toString(), // Show remaining characters for CVV
                      ),
                      maxLength: 4, // Limit CVV input to 4 characters
                      onChanged: (value) => setState(() => _cvv = value),
                    ),
                  ),
                ],
              ),
            ],
          ),
        Spacer(),
        ElevatedButton( 
          onPressed: _handlePayNow, 
          child: Text(
            'Pay Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueGrey), 
          minimumSize: MaterialStateProperty.all(Size(200, 50)), 

          foregroundColor: MaterialStateProperty.all(Colors.black), 

          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), 
          )),

          elevation: MaterialStateProperty.all(5.0), // Shadow elevation
          shadowColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.5)),

          overlayColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blueGrey.shade800; 
            }
            return Colors.transparent; 
          },
            ),
              ),
            ),
          const SizedBox(height: 20.0),
          ],
        ),
      ),
      ),
    );
  }
}