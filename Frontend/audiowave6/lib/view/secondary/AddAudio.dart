import 'package:audioplayers/audioplayers.dart';
import 'package:audiowave6/domain/repositories/metadata_repository.dart';
import 'package:audiowave6/domain/repositories/upload_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/audio.dart';
import '../../utils/storage_utils.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

import 'package:path/path.dart' as path;

class AddAudioPage extends StatefulWidget {
  final MetadataRepository metadataRepository;
  final UploadRepository uploadRepository;

  const AddAudioPage({
    super.key,
    required this.metadataRepository,
    required this.uploadRepository,
  });

  @override
  _AddAudioPageState createState() => _AddAudioPageState();
}

class _AddAudioPageState extends State<AddAudioPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  Uint8List? _thumbnail; // image
  String? _thumbnailFileName;
  Uint8List? _fileChecksumBytes;
  int? _fileSize;
  String? _fileType;
  int _durationSec = 0;
  List<int>? _audioBytes;
  PlatformFile? _audioFile;
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
        _audioBytes = result.files.single.bytes;
        _audioFile = result.files.single;
        _audioFileName = result.files.single.name; // Save the file name
        _fileSize = result.files.single.size;
        _fileType = result.files.single.extension;
        _durationSec = durationSecs;
        _fileChecksumBytes = _generateChecksum(_audioBytes!);
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

  Uint8List _generateChecksum(List<int> fileBytes) {
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
    // Validate input fields
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

    if (_audioBytes == null || _audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose an MP3 file.')),
      );
      return;
    }

    // Continue if validations pass
    try {
      setState(() {
        _isLoading = true;
      });

      // Create audio metadata
      Audio newAudio = Audio(
        id: 0,
        title: _titleController.text,
        description: _descriptionController.text,
        thumbnail: _thumbnail, // thumbnail can be null
        durationSec: _durationSec,
        fileSize: _fileSize,
        fileType: _fileType,
        fileChecksum: _fileChecksumBytes,
        visibilityId: _visibilityId,
        uploaderId: _uploaderId,
        tags: _tags,
      );

      int newAudioId = await widget.metadataRepository.addAudio(newAudio);
      print(newAudioId);

      String filePath = _audioFile?.path ?? "";
      final String outputDir = path.dirname(filePath);

      // Splitting the audio into 5 second chunks
      int chunkDuration = 5; //  in seconds
        String chunkDurationString = formatDuration(chunkDuration);
      int totalChunks = (_durationSec / chunkDuration)
          .ceil(); // Calculate total number of chunks

      String ffmpegCommand = "-i $filePath -f segment -segment_time $chunkDuration chunk_%03d.mp3";
      print("Executiong FFmpeg Command: $ffmpegCommand");
      await FFmpegKit.execute(ffmpegCommand);

      for (int chunkNumber = 0; chunkNumber < totalChunks; chunkNumber++) {
        // String chunkFileName = path.join(outputDir, 'chunk_$chunkNumber.mp3');
        String chunkFileName = 'chunk_${chunkNumber.toString().padLeft(3, '0')}.mp3';
        String chunkFilePath = path.join(outputDir, chunkFileName);
        print(chunkFileName);
        print(chunkFilePath);
        // String startTime = (chunkNumber * chunkDuration).toString();

        // FFmpeg command to split audio into chunks
        // var session = await FFmpegKit.execute(
        //   '-i $filePath -ss $startTime -t $chunkDuration -c:a libmp3lame -b:a 192k $chunkFileName',
        // );


        // String ffmpegCommand =
        //     "-i $filePath -ss $startTime -t $chunkDurationString -c copy $chunkFileName";
        // print("Executiong FFmpeg Command: $ffmpegCommand");
        // // var session = await FFmpegKit.execute(ffmpegCommand);

        // // final output = await session.getOutput();

        // // // print('FFmpeg Output: $output');

        // Read the chunk into bytes
        File chunkFile = File(chunkFilePath);
        Uint8List chunkBytes = await chunkFile.readAsBytes();

        try {
          http.MultipartFile multipartChunk = http.MultipartFile.fromBytes(
            'file',
            chunkBytes,
            filename: 'chunk_$chunkNumber.mp3',
          );

          // Upload the chunk
          await widget.uploadRepository.uploadChunk(
            newAudioId,
            chunkNumber + 1, // Chunks are 1-based
            totalChunks,
            chunkDuration,
            multipartChunk,
          );
        } catch (e) {
          print("Error Sending chunk: $e");
          throw e;
        } finally {
          await chunkFile.delete();
        }

      }

      setState(() {
        _isLoading = false;
      });

      print('Audio uploaded successfully with ID: $newAudioId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio uploaded successfully')),
      );

      Navigator.pop(context); // Close the modal after adding audio
    } catch (e) {
      print('Failed to upload audio: $e');

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload audio, please try again')),
      );
    }
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
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
      resizeToAvoidBottomInset:
          true, // This allows the layout to adjust when the keyboard is open
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),

            const Text(
              'Add New Audio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Audio Title',
                border: OutlineInputBorder(),
              ),
            ),

            // Description
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
                const Text(
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
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 16),

            // Audio File and Choose MP3 Button
            Row(
              children: [
                _audioBytes != null
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
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 16),

            // Tags input section
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Add Tags',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
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
      ),
    );
  }
}
