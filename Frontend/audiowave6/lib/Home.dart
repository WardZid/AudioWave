import 'Helpers/GeneralHelpers/AppBar.dart';
import 'Helpers/GeneralHelpers/BackGround.dart';
import 'Helpers/GeneralHelpers/SizedBoxes.dart';
import 'Registery/Register.dart';
import 'main.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarC(context, 'AudioWave', 30),
      body: Stack(
          children : [
            BG1(),
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(child: Text('List of Pages', style: TextStyle(
                      fontSize: 30
                  ),),),
                  h(20),
                  FilledButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)
                    => Register()));
                  }, child: Text('Register Page')),
                ],
              ),
            ),
          ]
      ),
    );
  }
}
