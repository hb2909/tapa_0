import 'package:flutter/material.dart';
import 'package:tapa_0/main.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tapa_0/helper/firebase_auth.dart';
import 'package:tapa_0/helper/validator.dart';

// class SignupScreen extends StatelessWidget {
//   const SignupScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Signup Screen'),
//       ),
//       // bottomNavigationBar: NavigationBar(
//       //   height: 80,
//       //   selectedIndex: 0,

//       //   destinations: const [
//       //     NavigationDestination(icon: Icon(Icons.person), label: 'User'),
//       //     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
//       //     NavigationDestination(icon: Icon(Icons.cloud), label: 'Weather'),
//       //   ],
//       // ),
//       // body: Container(),
//     );
//   }
// }


class SignupScreen extends StatefulWidget{
  @override
    _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Create Account'),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            ),
          centerTitle: true,
        ),
        body: 
          SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0,top: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/logo.png'),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30.0,top: 12),
                    child: Text(
                      'Create a new TAPA-0 account.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 38, 50, 56),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[ 
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(name: value),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(email: value),
                        decoration: InputDecoration(
                          hintText: "email@gmail.com",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        validator:(value) => Validator.validatePassword(password: value),
                        decoration: InputDecoration(
                          hintText: "Password must be more than 6 alphanumeric.",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.0,),
                      _isProcessing
                      ? CircularProgressIndicator()
                      : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isProcessing = true;
                                });

                                if (_registerFormKey.currentState!.validate()) {
                                  User? user = await FirebaseAuthHelper.registerUsingEmailPassword(
                                    name: _nameTextController.text, 
                                    email: _emailTextController.text, 
                                    password: _passwordTextController.text,
                                  );

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (user != null) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => 
                                          //HomeScreen(),
                                          //MyBottomNavigationBar(),
                                          LoginScreen(),
                                      ),
                                      ModalRoute.withName('/'),
                                      ); 
                                  }
                                }else{
                                  setState(() {
                                    _isProcessing = false;
                                  });
                                }

                              }, child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                    fontSize: 20,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      //),
    );
  }
}
  