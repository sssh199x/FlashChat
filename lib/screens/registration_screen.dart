import 'package:flashchat/components/my_button.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  //Creating an instance of authorization from FirebaseAuth
  final _auth = FirebaseAuth.instance;
  UserCredential? user;
  String? userName;
  String? password;
  String? errorMessage;
  bool isSpinning = false;
  @override
  Widget build(BuildContext context) {
    // double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isSpinning,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: h / 3,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 48.0,
              // ),
              Expanded(
                flex: 0,
                child: TextFieldWithBackgroundGif(
                  labelText: 'Enter your e-mail...',
                  onChanged: (value) {
                    userName = value;
                  },
                ),
              ),

              // TextField(
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(color: Colors.black),
              //     onChanged: (value) {
              //       //Do something with the user input.

              //       userName = value;
              //     },
              //     decoration:
              //         MyButton.getInputDecoration('Enter your e-mail...')),
              // const SizedBox(
              //   height: 8.0,
              // ),
              Expanded(
                flex: 0,
                child: TextFieldWithBackgroundGif(
                  labelText: 'Enter your password...',
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              // TextField(
              //     style: const TextStyle(color: Colors.black),
              //     obscureText: true,
              //     textAlign: TextAlign.center,
              //     onChanged: (value) {
              //       //Do something with the user password.
              //       password = value;
              //     },
              //     decoration:
              //         MyButton.getInputDecoration('Enter your password...')),
              const SizedBox(
                height: 5.0,
              ),
              // MyButton.getErrorMessage(errorMessage),
              MyButton(
                  onPressed: () async {
                    print(userName);
                    print(password);

                    setState(() {
                      isSpinning = true;
                    });

                    try {
                      user = await _auth.createUserWithEmailAndPassword(
                          email: userName!, password: password!);
                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    } catch (e) {
                      print(' Original Exception is : $e');

                      String signInErrorMessage;
                      if (e is FirebaseAuthException) {
                        print(e.code);
                        switch (e.code) {
                          case 'email-already-in-use':
                            signInErrorMessage =
                                'This email is already in use.';
                            break;
                          case 'channel-error':
                            signInErrorMessage =
                                'Please enter both email and password.';
                            break;
                          case 'weak-password':
                            signInErrorMessage = 'Your password is to weak!';
                            break;

                          case 'invalid-email':
                            signInErrorMessage =
                                'Email not found. Please check your email.';

                            break;

                          default:
                            signInErrorMessage =
                                'An error occurred. Please try again later.';
                            break;
                        }
                      } else {
                        signInErrorMessage =
                            'An error occurred. Please  input the fields correctly.';
                      }
                      setState(() {
                        errorMessage = signInErrorMessage;
                      });
                      print('Modified Exception is : $errorMessage');

                      throw Fluttertoast.showToast(
                          msg: '$errorMessage', backgroundColor: Colors.red);
                    } finally {
                      setState(() {
                        isSpinning = false;
                      });
                    }
                  },
                  buttonName: 'Register',
                  colour: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
