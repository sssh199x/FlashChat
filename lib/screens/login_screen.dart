import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/components/my_button.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String? userName;
  String? password;
  UserCredential? signedInUser;
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
                    labelText: 'Enter your Email',
                    onChanged: (value) {
                      userName = value;
                    },
                  )),
              // TextField(
              //   textAlign: TextAlign.center,

              //   style: const TextStyle(
              //     color: Colors.black,
              //   ),
              //   onChanged: (value) {
              //     //Do something with the user input.
              //     userName = value;
              //   },
              //   decoration: MyButton.getInputDecoration('Enter your e-mail...'),

              // ),
              // const SizedBox(
              //   height: 8.0,
              // ),
              Expanded(
                flex: 0,
                child: TextFieldWithBackgroundGif(
                  labelText: 'Enter your password',
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              // TextField(
              //   textAlign: TextAlign.center,
              //   obscureText: true,
              //   style: const TextStyle(color: Colors.black),
              //   onChanged: (value) {
              //     //Do something with the user input.
              //     password = value;
              //   },
              //   decoration:
              //       MyButton.getInputDecoration('Enter your password...'),
              // ),
              const SizedBox(
                height: 5.0,
              ),
              MyButton.getErrorMessage(errorMessage),

              MyButton(
                colour: Colors.lightBlueAccent,
                buttonName: 'Log In',
                onPressed: () async {
                  print(userName);
                  print(password);
                  setState(() {
                    isSpinning = true;
                  });

                  try {
                    signedInUser = await _auth.signInWithEmailAndPassword(
                        email: userName!, password: password!);
                    print(signedInUser);

                    if (signedInUser != null) {
                      Navigator.pushReplacementNamed(context, ChatScreen.id);
                    }
                  } catch (e) {
                    print(' Original Exception is : $e');

                    String signInErrorMessage;
                    if (e is FirebaseAuthException) {
                      print(e.code);
                      switch (e.code) {
                        case 'user-not-found':
                          signInErrorMessage =
                              'There is no user corresponding to the given email';
                          break;
                        case 'channel-error':
                          signInErrorMessage =
                              'Please enter both email and password.';
                          break;
                        case 'user-disabled':
                          signInErrorMessage =
                              'You are disabled from this app Motherfukcer!';
                          break;

                        case 'invalid-email':
                          signInErrorMessage =
                              'Email not found. Please check your email.';

                          break;
                        case 'wrong-password':
                          signInErrorMessage =
                              'Incorrect password. Please try again.';
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
                  } finally {
                    setState(() {
                      isSpinning = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
