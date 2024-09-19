import 'package:audioplayers/audioplayers.dart';
import 'package:audiowave6/domain/repositories/metadata_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/audio.dart';
import '../../utils/storage_utils.dart';

class AddAudioPage extends StatefulWidget {
  final MetadataRepository metadataRepository;

  const AddAudioPage({super.key, required this.metadataRepository});

  @override
  _AddAudioPageState createState() => _AddAudioPageState();
}

class _AddAudioPageState extends State<AddAudioPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  Uint8List? _thumbnail; // image
  String? _thumbnailFileName;
  Uint8List? _fileChecksum;
  int? _fileSize;
  String? _fileType;
  int _durationSec = 0;
  Uint8List? _audioFile;
  String? _audioFileName;
  int _visibilityId = 1; // Default visibility (public)
  int? _uploaderId;
  bool _isLoading = false;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _getUploaderId();
  }

  Future<void> _getUploaderId() async {
    try {
      String userStr = (await StorageUtils.getUserId()) ?? "-1";
      int userId = int.parse(userStr);
      setState(() {
        _uploaderId = userId;
      });
    } catch (e) {
      print("ERROR - AddAudio -  _getUploaderId: $e");
      throw e;
    }
  }

  Future<void> _pickThumbnail() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);
    if (result != null) {
      setState(() {
        _thumbnail = result.files.first.bytes;
        _thumbnailFileName = result.files.first.name; // Save the file name
      });
    }
  }

  Future<void> _pickAudioFile() async {
    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true, type: FileType.custom, allowedExtensions: ['mp3']);

    if (result != null) {
      File file = File(result.files.single.path!);
      int durationSecs = await _getAudioDuration(file);
      setState(() {
        _audioFile = result.files.single.bytes;
        _audioFileName = result.files.single.name; // Save the file name
        _fileSize = result.files.single.size;
        _fileType = result.files.single.extension;
        _durationSec = durationSecs;
        _fileChecksum = _generateChecksum(_audioFile!);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<int> _getAudioDuration(File file) async {
    AudioPlayer audioPlayer = AudioPlayer();
    int duration = 0;

    try {
      await audioPlayer.setSourceDeviceFile(file.path);
      duration = (await audioPlayer.getDuration())?.inSeconds ?? 0;
    } catch (e) {
      print("Error getting audio duration: $e");
    } finally {
      await audioPlayer.dispose();
    }
    print("Calculated Duration: $duration");
    return duration;
  }

  Uint8List _generateChecksum(Uint8List fileBytes) {
    // calc md5 hash
    Digest md5Hash = md5.convert(fileBytes);

    // convert to Uint8List
    return Uint8List.fromList(md5Hash.bytes);
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag); // Add tag to the list
      });
    }
    _tagsController.clear(); // Clear the input field after adding
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag); // Remove tag from the list
    });
  }

  Future<void> _uploadAudio() async {
    // Validate  fields
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the audio title.')),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the audio description.')),
      );
      return;
    }

    if (_audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose an MP3 file.')),
      );
      return;
    }

    // contin if validations pass
    try {
      setState(() {
        _isLoading = true;
      });

      Audio newAudio = Audio(
        id: 0,
        title: _titleController.text,
        description: _descriptionController.text,
        thumbnail: _thumbnail, // thumbnail can be null
        durationSec: _durationSec,
        fileSize: _fileSize,
        fileType: _fileType,
        fileChecksum: _fileChecksum,
        visibilityId: _visibilityId,
        uploaderId: _uploaderId,
        tags: _tags
      );

      // Call the repository to upload the audio
      int newAudioId = await widget.metadataRepository.addAudio(newAudio);
      print("asdasd");
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Audio uploaded successfully with ID: $newAudioId')),
      );

      
      Navigator.pop(context); // Close the modal after adding audio



    } catch (e) {

      print(e); 

      setState(() {
        _isLoading = false;
      });

      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload audio: $e')),
      );
    }
  }

  Widget _buildTag(String tag) {
    return Chip(
      label: Text(tag),
      onDeleted: () {
        _removeTag(tag); // Remove tag when the delete icon is pressed
      },
    );
  }

  // Helper method to build each visibility option
  Widget _buildVisibilityOption(int value, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _visibilityId = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: _visibilityId == value ? Colors.purple : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: _visibilityId == value ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 24),

          const Text(
            'Add New Audio',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // title
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Audio Title',
              border: OutlineInputBorder(),
            ),
          ),

          // description
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Audio Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Visibility Section with Title and Options
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visibility:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVisibilityOption(1, 'Public'),
                  _buildVisibilityOption(2, 'Private'),
                  _buildVisibilityOption(3, 'Unlisted'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Thumbnail and Upload Button
          Row(
            children: [
              _thumbnail != null
                  ? Image.memory(
                      _thumbnail!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _pickThumbnail,
                  child: const Text('Upload Thumbnail'),
                ),
              ),
            ],
          ),
          if (_thumbnailFileName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Thumbnail: $_thumbnailFileName',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          const SizedBox(height: 16),

          // Audio File and Choose MP3 Button
          Row(
            children: [
              _audioFile != null
                  ? const Icon(
                      Icons.audiotrack,
                      size: 50,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.audiotrack,
                      size: 50,
                      color: Colors.grey,
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _pickAudioFile,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Choose MP3 File'),
                ),
              ),
            ],
          ),

          if (_audioFileName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'MP3 File: $_audioFileName',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

          const SizedBox(height: 16),

          // Tags input section
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              labelText: 'Add Tags',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _addTag(_tagsController.text),
              ),
            ),
            onSubmitted: _addTag, // Add tag on submission
          ),
          const SizedBox(height: 16),

          // Display the added tags as Chips
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _tags.map((tag) => _buildTag(tag)).toList(),
          ),
          const SizedBox(height: 16),


          const Spacer(), // Push the upload button to the bottom

          // Upload Audio Button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _uploadAudio,
                  child: const Text('Upload Audio'),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
