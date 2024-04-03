import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tapa_0/main.dart';
import 'package:tapa_0/screens/home.dart';
import 'package:tapa_0/screens/weather.dart';
import 'package:tapa_0/screens/user.dart';
import 'package:tapa_0/screens/signup.dart';
import 'package:tapa_0/screens/login.dart';
import 'package:tapa_0/helper/firebase_auth.dart';
import 'package:tapa_0/helper/validator.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Login Screen'),
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


class LoginScreen extends StatefulWidget {
@override
_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final _formKey = GlobalKey<FormState>();

final _emailTextController = TextEditingController();
final _passwordTextController = TextEditingController();

final _focusEmail = FocusNode();
final _focusPassword = FocusNode();

bool _isProcessing = false;

Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        // builder: (context) => HomeScreen(),
        builder: (context) => MyBottomNavigationBar(),
      ),
    );
  }

  return firebaseApp;
}

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      _focusEmail.unfocus();
      _focusPassword.unfocus();
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('TAPA-0 Log In'),
        titleTextStyle: TextStyle(
          color: Colors.white,  
          fontSize: 20.0,
          ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
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
                      'Log in to TAPA-0.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 38, 50, 56),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        _isProcessing
                        ? CircularProgressIndicator()
                        : Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  _focusEmail.unfocus();
                                  _focusPassword.unfocus();

                                  if (_formKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      _isProcessing = true;
                                    });

                                    User? user = await FirebaseAuthHelper
                                        .signInUsingEmailPassword(
                                      email: _emailTextController.text,
                                      password:
                                          _passwordTextController.text,
                                    );

                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    if (user != null) {
                                      Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              //HomeScreen(),
                                              MyBottomNavigationBar(),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                                ),
                              ),
                            ),
                            SizedBox(width: 24.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text(
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
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ),
  );
}
}