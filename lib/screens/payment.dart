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

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }


// class _PaymentScreenState extends State<PaymentScreen> {
//   String _selectedPaymentMethod = 'card'; // Default selection

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey,
//         title: Text('Payment'),
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 20.0,
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Expanded(
//                 child: ElevatedButton(
//                   onPressed: () => setState(() => _selectedPaymentMethod = 'ewallet'),
//                   child: Text(
//                     _selectedPaymentMethod == 'ewallet' ? 'E-Wallet (Selected)' : 'E-Wallet',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _selectedPaymentMethod == 'ewallet' ? Colors.blue : Colors.blueGrey,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8),
//                 Expanded(
//                 child: ElevatedButton(
//                   onPressed: () => setState(() => _selectedPaymentMethod = 'card'),
//                   child: Text(
//                     _selectedPaymentMethod == 'card' ? 'Card (Selected)' : 'Card',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _selectedPaymentMethod == 'ewallet' ? Colors.blue : Colors.blueGrey,
//                   ),
//                 ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.0),
//             if (_selectedPaymentMethod == 'ewallet')
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: 'E-Wallet Number/Username',
//                 ),
//               ),
//             if (_selectedPaymentMethod == 'card')
//               Column(
//                 children: [
//                   TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Card Number',
//                     ),
//                   ),
//                   SizedBox(height: 10.0),
//                   Row(
//                     children: [
//                       Flexible(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'Expiry Date (MM/YY)',
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.0),
//                       Flexible(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             labelText: 'CVV',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             SizedBox(height: 50),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context)
//                     .pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         //HomeScreen(),
//                         //ConnectionScreen(),
//                         MyBottomNavigationBar(),
//                   ),
//                 );
//               },
//               child: Text(
//                 'Pay Now',
//                 style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
//                     minimumSize: MaterialStateProperty.all(Size(150, 50)),
//                   ),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for required field check

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card'; // Default selection
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';

  bool _validateCardNumber(String cardNumber) {
    // Replace with a robust regular expression for card number validation
    // You can find libraries like 'card_validator' for this purpose
    return cardNumber.length >= 16; // Placeholder validation
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


  bool _validateForm() {
    if (_selectedPaymentMethod == 'card') {
      if (!_validateCardNumber(_cardNumber)) {
        return false;
      }
      if (!_validateExpiryDate(_expiryDate)) {
        return false;
      }
      if (!_validateCvv(_cvv)) {
        return false;
      }
    }
    return true; // Form is valid
  }

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
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPaymentMethod == 'ewallet' ? Colors.blue : Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0), // Using const constructor
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
        keyboardType: TextInputType.number, // For card number
        decoration: InputDecoration(
          labelText: 'Card Number',
          errorText: _validateCardNumber(_cardNumber) ? null : 'Invalid card number',
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
              onChanged: (value) => setState(() => _expiryDate = value), // Ensure correct spelling
            ),
          ),
          const SizedBox(width: 10.0), // Using const constructor
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
  )]
   ),
      ),
    );
  }
}