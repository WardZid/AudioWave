import 'package:flutter/material.dart';

class AudioBlockHelper {
  static Widget buildAudioBlock({
    required String audioName,
    required String creatorName,
    required String description,
    required String duration,
    required int listening,
    required String uploadDate,
    required int size,
    required String type,
    required bool showDetails,
    required String imagePath, // New parameter for image
    required double containerHeight, // New parameter for size
    required Function() onTap,
    required Function() onDoubleTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 15, 10),
      child: Container(
        height: containerHeight, // Using size here
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              image: DecorationImage(
                image: AssetImage(imagePath), // Use the image passed from the main file
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    audioName,
                    style: const TextStyle(fontSize: 33),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ),
                showDetails
                    ? Column(
                  children: [
                    _buildDetail('Creator', creatorName),
                    _buildDetail('Description', description),
                    _buildDetail('Audio Duration', duration),
                    _buildDetail('Listened', '$listening times'),
                    _buildDetail('Uploaded on', uploadDate),
                    _buildDetail('Audio File Size', size.toString()),
                    _buildDetail('Audio File Type', type),
                  ],
                )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 33),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
      ),
    );
  }
}
