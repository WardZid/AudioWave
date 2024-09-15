import 'package:audiowave6/Helpers/GeneralHelpers/AppBar.dart';
import 'package:audiowave6/Helpers/GeneralHelpers/SizedBoxes.dart';
import 'package:audiowave6/Helpers/GeneralHelpers/TextBox.dart';
import 'package:flutter/material.dart';

import '../Helpers/GeneralHelpers/BackGround.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Variables
  TextEditingController _Email = TextEditingController();
  TextEditingController _Pass = TextEditingController();
  bool emailEmpty = false;
  bool passEmpty = false;
  String emailBox = 'Your email cannot be empty!';
  String passBox = 'Your password cannot be empty!';
  // Variables

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarC(context, 'Sign In', 30),
      body: Stack(
        children: [
          BG1(),
          SingleChildScrollView(
            child: Column(
              children: [
                h(10),
                Center(
                  child: Text(
                    'Please Sign In',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                TextBoxC(_Email, 'Please Enter your Email'),
                TextBoxC(_Pass, 'Please Enter your Password'),
                h(10),
                emailEmpty
                    ? Text(
                  emailBox,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                )
                    : SizedBox(),
                passEmpty
                    ? Text(
                  passBox,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                )
                    : SizedBox(),
                h(20),
                FilledButton(
                  onPressed: () {
                    if (_Email.text == '' || _Email.text == ' ') {
                      setState(() {
                        emailEmpty = true;
                      });
                    } else {
                      setState(() {
                        emailEmpty = false;
                      });
                    }
                    if (_Pass.text == '' || _Pass.text == ' ') {
                      setState(() {
                        passEmpty = true;
                      });
                    } else {
                      setState(() {
                        passEmpty = false;
                      });
                    }

                    if (!emailEmpty && !passEmpty) {
                      // Add your sign-in logic here
                    }
                  },
                  child: Text('Sign In'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
