import 'package:flutter/material.dart';
import 'package:audiowave6/view/Helpers/GeneralHelpers/AppBar.dart';
import 'package:audiowave6/view/Helpers/GeneralHelpers/Blocks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List AudiNames = ['test1', 'test2', 'test3'];
  List CreatorNames = ['test1', 'test2', 'test3'];
  List descriptions = ['test1', 'test2', 'test3'];
  List Durations = ['test1', 'test2', 'test3'];
  List Listening = [10, 20, 30];
  List UploadDate = ['test1', 'test2', 'test3'];
  List Sizes = [10, 20, 30]; // Sizes for the container
  List Types = ['test1', 'test2', 'test3'];
  List imagePaths = ['assets/BG1.jpg', 'assets/BG2.jpg', 'assets/BG3.jpg']; // Images for the audio files
  int len = 0;
  bool show = false;

  @override
  void initState() {
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
            ),
            itemCount: len,
            itemBuilder: (BuildContext context, int index) {
              return AudioBlockHelper.buildAudioBlock(
                audioName: AudiNames[index],
                creatorName: CreatorNames[index],
                description: descriptions[index],
                duration: Durations[index],
                listening: Listening[index],
                uploadDate: UploadDate[index],
                size: Sizes[index],
                type: Types[index],
                showDetails: show,
                imagePath: imagePaths[index], // Passing the image path
                containerHeight: Sizes[index].toDouble(), // Passing the size as height
                onTap: () {
                  // handle tap event
                },
                onDoubleTap: () {
                  setState(() {
                    show = !show;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
