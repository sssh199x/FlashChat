import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  //animation  for flash chat
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    // Calls the listener every time the value of the animation changes.
    // Listeners can be removed with [removeListener].
    _controller.addListener(() {
      setState(() {});
      //prints out the value of _controller in double datatype
      print('_controller value : ${_controller.value}');
      // prints out the value between 0 and 1 that is applied to the _controller.value along with the curve applied accordingly
      print('animation value : ${_animation.value}');
    });

    _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_controller);

    // _animation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInBack,
    // );
    // _animation1 = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.decelerate,
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      width: w / 4,
                      height: h / 4,
                      child: Image.asset('assets/images/logo.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                            color: Colors.black12,
                            blurRadius: 0.5,
                            offset: Offset(20, 20))
                      ],
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Oswald'),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Flash Chat'),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            MyButton(
              onPressed: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.id);
              },
              buttonName: 'Login',
              colour: Colors.lightBlueAccent,
            ),
            MyButton(
                buttonName: 'Register',
                onPressed: () {
                  //Go to login screen.
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                colour: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
