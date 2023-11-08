import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String buttonName;
  final Color colour;
  const MyButton({
    super.key,
    required this.colour,
    required this.buttonName,
    required this.onPressed,
  });

  static InputDecoration getInputDecoration(String textlabel) {
    return InputDecoration(
      labelText: textlabel,
      labelStyle: const TextStyle(
          fontSize: 18,
          height: 0.2,
          color: Colors.black,
          letterSpacing: 2.0,
          fontWeight: FontWeight.w800),
      // hintText: textHint,
      // hintStyle: const TextStyle(letterSpacing: 2, color: Colors.black),
      //to shift the content on screen when keyboard shows up
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      //to show the text field when the pw textfield is selected
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 2.0),
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 4.0),
        borderRadius: BorderRadius.all(Radius.zero),
      ),
    );
  }

  static Expanded getErrorMessage(String? messageError) {
    return Expanded(
      flex: 0,
      child: Visibility(
        visible:
            messageError != null, // Only show when there's an error message.
        child: Text(
          messageError ?? '', // Display the error message if it's not null.
          style: const TextStyle(
            color: Colors.red, // Customize the text color for errors.
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          visualDensity: VisualDensity.standard,
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonName,
            style: const TextStyle(
                letterSpacing: 2.0, fontFamily: 'Oswald', fontSize: 22),
          ),
        ),
      ),
    );
  }
}

class TextFieldWithBackgroundGif extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  final bool obscureText;
  final String labelText;
  final TextAlign textAlign;
  final TextStyle style;

  const TextFieldWithBackgroundGif({
    super.key,
    this.onChanged,
    this.obscureText = false,
    this.textAlign = TextAlign.center,
    this.style = const TextStyle(color: Colors.black),
    required this.labelText,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: Container(
              width: 332,
              height: 48,

              // Set the background GIF image here
              child: Image.asset(
                'assets/images/typing.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              obscureText: obscureText,
              onChanged: onChanged,
              textAlign: textAlign,
              style: style,
              decoration: MyButton.getInputDecoration(labelText),
            ),
          ),
        ),
      ],
    );
  }
}
