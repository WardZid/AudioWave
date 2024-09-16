import 'package:flutter/material.dart';

class AddAudioPage extends StatelessWidget {
  const AddAudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make sure it takes up only the required height
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Audio',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Audio Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Audio Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3, // Allow multiple lines for description
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle audio upload logic
              print("Audio Uploaded");
              Navigator.pop(context); // Close the modal after adding audio
            },
            child: const Text('Upload Audio'),
          ),
        ],
      ),
    );
  }
}
