import 'package:audiowave6/view/Helpers/GeneralHelpers/AppBar.dart';
import 'package:audiowave6/view/Helpers/GeneralHelpers/SizedBoxes.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // code
  // Variables
  List AudiNames = ['test1', 'test2', 'test3', 'test1', 'test2', 'test3'];
  List CreatorNames = ['test1', 'test2', 'test3', 'test1', 'test2', 'test3'];
  List descriptions = ['test1', 'test2', 'test3', 'test1', 'test2', 'test3'];
  List Durations = ['test1', 'test2', 'test3', 'test1', 'test2', 'test3'];
  List Listening = [10, 20, 30, 10, 20, 30];
  List UploadDate = ['test1', 'test2', 'test3', 'test1', 'test2', 'test3'];
  List Sizes = [10, 20, 30, 10, 20 ,30];
  List Types = ['test1', 'test2', 'test3', 'test1', 'test2', 'test3'];
  List Topics = ['topic1', 'topic2', 'topic3', 'topic4', 'topic5', 'topic6'];
  List ids = [1, 2, 3, 1, 2, 3];
  List<int> UploaderIds = [11, 22, 33, 11, 22, 33];
  int len = 0;
  bool show = false;
  bool show2 = false;
  double height = 100;
  double width = 100;
  double height2 = 100;
  double width2 = 100;
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
          SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('  Trending', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int index = 0; index < len; ++ index)
                          Padding(padding: EdgeInsets.fromLTRB(20, 15, 15, 10),
                            child: Container(color: Colors.white,
                              child: InkWell(
                                onTap: (){
            
                                },
                                onDoubleTap: (){
                                  setState(() {
                                    show = !show;
                                    if (height == 100) {
                                      setState(() {
                                        height = 350;
                                        width = 300;
                                      });
                                    }
                                    else if (height == 350) {
                                      setState(() {
                                        height = 100;
                                        width = 100;
                                      });
                                    }
                                  });
                                },
                                onLongPress: (){
            
                                },
                                child: Container(
                                  height: height,
                                  width: width,
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
                                            child: Text('Creator: ' + CreatorNames[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Description: ' + descriptions[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Audio Duration: ' + Durations[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Listened: ' + Listening[index].toString() + ' times', style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Uploaded on: ' + UploadDate[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Audio File Size: ' + Sizes[index].toString(), style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Audio File Type: ' + Types[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                        ],
                                      ) : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ),),
                      ],
                    ),
                  ),
                  h(25),
                  Text('  Top Playlists', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int index = 0; index < len; ++ index)
                          Padding(padding: EdgeInsets.fromLTRB(20, 15, 15, 10),
                            child: Container(color: Colors.white,
                              child: InkWell(
                                onTap: (){
            
                                },
                                onDoubleTap: (){
                                  setState(() {
                                    show2 = !show2;
                                    if (height2 == 100) {
                                      setState(() {
                                        height2 = 350;
                                        width2 = 300;
                                      });
                                    }
                                    else if (height2 == 350) {
                                      setState(() {
                                        height2 = 100;
                                        width2 = 100;
                                      });
                                    }
                                  });
                                },
                                onLongPress: (){
            
                                },
                                child: Container(
                                  height: height2,
                                  width: width2,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    image: DecorationImage(image: AssetImage('assets/BG1.jpg'),
                                        fit: BoxFit.fill),
                                  ),
                                  child: Column (
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Text(AudiNames[index%2], style: TextStyle(fontSize: 33),
                                          textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                      show2 ? Column(
                                        children: [
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Creator: ' + CreatorNames[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Description: ' + descriptions[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Audio Duration: ' + Durations[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Listened: ' + Listening[index].toString() + ' times', style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Uploaded on: ' + UploadDate[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Audio File Size: ' + Sizes[index].toString(), style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: Text('Audio File Type: ' + Types[index], style: TextStyle(fontSize: 26),
                                              textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
            
                                        ],
                                      ) : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ),),
                      ],
                    ),
                  ),
                  h(25),
                  Center(child: Text('Topics', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int index = 0; index < len; ++ index)
                          Padding(padding: EdgeInsets.fromLTRB(20, 15, 15, 10),
                            child: Container(color: Colors.white,
                              child: InkWell(
                                onTap: (){

                                },
                                onDoubleTap: (){

                                },
                                onLongPress: (){

                                },
                                child: Container(
                                  height: 250,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    image: DecorationImage(image: AssetImage('assets/BG1.jpg'),
                                        fit: BoxFit.fill),
                                  ),
                                  child: Column (
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Text(Topics[index], style: TextStyle(fontSize: 33),
                                          textDirection: TextDirection.rtl, textAlign: TextAlign.center,),),
                                    ],
                                  ),
                                ),
                              ),
                            ),),
                      ],
                    ),
                  ),
            
                ],
              ),
          ),
        ],
      ),
    );
  }
}
