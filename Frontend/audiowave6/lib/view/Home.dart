import 'package:audiowave6/view/Helpers/GeneralHelpers/AppBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // code
  // Variables
  List AudiNames = ['test1', 'test2', 'test3'];
  List CreatorNames = ['test1', 'test2', 'test3'];
  List descriptions = ['test1', 'test2', 'test3'];
  List Durations = ['test1', 'test2', 'test3'];
  List Listening = [10, 20, 30];
  List UploadDate = ['test1', 'test2', 'test3'];
  List Sizes = [10, 20, 30];
  List Types = ['test1', 'test2', 'test3'];
  List ids = [1, 2, 3];
  List<int> UploaderIds = [11, 22, 33];
  int len = 0;
  bool show = false;
  // Variables
  // Functions
  // Functions
  // Widgets
  // Widgets
  // code
  @override
  void initState(){
    super.initState();
    len = AudiNames.length;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarC(context, 'Audio Wave', 30),
      body: Stack(
        children: [
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,),
              itemCount: len,
              itemBuilder: (BuildContext context, int index) {
                return Padding(padding: EdgeInsets.fromLTRB(20, 15, 15, 10),
                  child: Container(color: Colors.white,
                    child: InkWell(
                      onTap: (){

                      },
                      onDoubleTap: (){
                        setState(() {
                          show = !show;
                        });
                      },
                      onLongPress: (){

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          image: DecorationImage(image: AssetImage('assets/BG1.jpg'),
                          fit: BoxFit.fill),
                        ),
                        child: Column (
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(AudiNames[index], style: TextStyle(fontSize: 33),
                                textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                            show ? Column(
                              children: [
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text('Creator: ' + CreatorNames[index], style: TextStyle(fontSize: 33),
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text('Description: ' + descriptions[index], style: TextStyle(fontSize: 33),
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text('Audio Duration: ' + Durations[index], style: TextStyle(fontSize: 33),
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text('Listened: ' + Listening[index].toString() + ' times', style: TextStyle(fontSize: 33),
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text('Uploaded on: ' + UploadDate[index], style: TextStyle(fontSize: 33),
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text('Audio File Size: ' + Sizes[index].toString(), style: TextStyle(fontSize: 33),
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text('Audio File Type: ' + Types[index], style: TextStyle(fontSize: 33),
                                    textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),

                              ],
                            ) : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),);
              }
          ),
        ],
      ),
    );
  }
}
