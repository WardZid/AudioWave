import 'package:audiowave6/Helpers/GeneralHelpers/AppBar.dart';
import 'package:audiowave6/Helpers/GeneralHelpers/SizedBoxes.dart';
import 'package:audiowave6/Helpers/GeneralHelpers/TextBox.dart';
import 'package:flutter/material.dart';
//import 'package:audiowave6/lib/Registery/Signin.dart';
import '../Helpers/GeneralHelpers/BackGround.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // code
  // Variables
  TextEditingController _Email  = TextEditingController();
  TextEditingController _UserName  = TextEditingController();
  TextEditingController _Pass  = TextEditingController();
  TextEditingController _Pass2  = TextEditingController();
  bool match = false;
  bool userNameEmpty = false;
  bool emailEmpty = false;
  String passwordMatch = 'your passwords dont match!';
  String usernameBox = 'your user name can not be empty!';
  String emailBox = 'your email can not be empty!';
  // Variables
  // Functions
  // Functions
  // Widgets
  // Widgets
  // code
  @override
  void initState () {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBarC(context, 'Register', 30),
      body: Stack(
        children: [
          BG1(),
          SingleChildScrollView(

            child: Column(
              children: [
                h(120),
                Center(child: Text('Please Register', style: TextStyle(fontSize: 30),),),
                TextBoxC(_Email, 'Please Enter your Email'),
                TextBoxC(_UserName, 'Please Enter your User Name'),
                TextBoxC(_Pass, 'Please Enter your Password'),
                TextBoxC(_Pass2, 'Please Repeat your Password'),
                h(10),
                userNameEmpty ? Text(usernameBox,style:
                TextStyle(fontSize: 18, color: Colors.red),)
                : SizedBox(),
                emailEmpty ? Text(emailBox,style:
                TextStyle(fontSize: 18, color: Colors.red),)
                : SizedBox(),
                match ? Text(passwordMatch,style:
                TextStyle(fontSize: 18, color: Colors.red),)
                    : SizedBox(),
                h(20),
                FilledButton(onPressed: (){
                  if (_UserName.text == '' || _UserName.text == ' ') {
                    setState(() {userNameEmpty = true;});
                  }
                  if (_Email.text == '' || _Email.text == ' ') {
                    setState(() {emailEmpty = true;});
                  }
                  if (_Pass.text != _Pass2.text) {
                    setState(() {match = true;});
                  }
                  if (_Pass.text == _Pass2.text) {
                    setState(() {
                      match = false;
                      emailEmpty = false;
                      userNameEmpty = false;
                    // here write the code for registration
                      //Navigator.push(context, MaterialPageRoute(builder: (context)
                     // => Signin()));
                    });
                  }
                }, child: Text('Register')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
