import 'package:flutter/material.dart';
import 'package:audiowave6/domain/repositories/metadata_repository.dart';
import 'package:audiowave6/domain/repositories/upload_repository.dart';
import '../../domain/entities/audio.dart';
import '../../utils/storage_utils.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:http_parser/http_parser.dart';

class AddAudioPage extends StatefulWidget {
  final MetadataRepository metadataRepository;
  final UploadRepository uploadRepository;

  const AddAudioPage({
    Key? key,
    required this.metadataRepository,
    required this.uploadRepository,
  }) : super(key: key);

  @override
  _AddAudioPageState createState() => _AddAudioPageState();
}

class _AddAudioPageState extends State<AddAudioPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  double _uploadProgress = 0.0;

  Uint8List? _thumbnail; // image
  String? _thumbnailFileName;
  Uint8List? _fileChecksumBytes;
  int? _fileSize;
  String? _fileType;
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
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _audioBytes = result.files.single.bytes;
        _audioFile = result.files.single;
        _audioFileName = result.files.single.name; // Save the file name
        _fileSize = result.files.single.size;
        _fileType = result.files.single.extension;
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
    int duration = 0;
    try {
      final session = await FFprobeKit.getMediaInformation(file.path);
      final information = await session.getMediaInformation();
      if (information != null) {
        final durationStr = information.getDuration();
        if (durationStr != null) {
          duration = double.parse(durationStr).ceil();
        }
      }
    } catch (e) {
      print("Error getting audio duration: $e");
    }
    print("Calculated Duration: $duration");
    return duration;
  }

  Uint8List _generateChecksum(List<int> fileBytes) {
    // Calculate MD5 hash
    Digest md5Hash = md5.convert(fileBytes);
    // Convert to Uint8List
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
        const SnackBar(content: Text('Please enter the audio title.')),
      );
      return;
    }

    if (_audioBytes == null || _audioFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose an MP3 file.')),
      );
      return;
    }

    // Continue if validations pass
    try {
      setState(() {
        _isLoading = true;
        _uploadProgress = 0.0;
      });

      await splitAndUpload(_audioFile!);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio uploaded successfully')),
      );

      Navigator.pop(context, true); // Close the modal and return true
    } catch (e) {
      print('Failed to upload audio: $e');

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload audio, please try again')),
      );
    }
  }

  Future<int> uploadAudioMetadata(int durationSeconds, String fileType) async {
    Audio newAudio = Audio(
      id: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      thumbnail: _thumbnail, // thumbnail can be null
      durationSec: durationSeconds,
      fileSize: _fileSize,
      fileType: fileType,
      fileChecksum: _fileChecksumBytes,
      visibilityId: _visibilityId,
      uploaderId: _uploaderId,
      tags: _tags,
    );

    int newAudioId = await widget.metadataRepository.addAudio(newAudio);
    print('Audio metadata uploaded successfully with ID: $newAudioId');
    return newAudioId;
  }

  Future<void> splitAndUpload(PlatformFile mp3File) async {
    final cleanedFile = await cleanMetadata(File(mp3File.path!));

    final totalDuration = await _getAudioDuration(cleanedFile);

    // Calculate total chunks (each chunk is 5 seconds)
    final totalChunks = (totalDuration / 5).ceil();

    final audioId = await uploadAudioMetadata(totalDuration, "wav");

    print('Total duration: $totalDuration seconds');
    print('Total chunks: $totalChunks');

    await splitAndUploadChunks(
        cleanedFile, 5, totalDuration, audioId, totalChunks); // Process each chunk and upload
  }

  Future<void> splitAndUploadChunks(File mp3File, int chunkDurationSecs,
      int totalDuration, int audioId, int totalChunks) async {
    final tempDir = await getTemporaryDirectory();
    int index = 0;
    bool splitSuccess = true;

    while (splitSuccess) {
      final outputPath = '${tempDir.path}/chunk_$index.wav';
      int startTime = index * chunkDurationSecs;

      if (startTime >= totalDuration) {
        print("All chunks processed.");
        break;
      }

      final command =
          '-y -i "${mp3File.path}" -ss $startTime -t $chunkDurationSecs -c:a pcm_s16le "$outputPath"';

      print("FFmpeg command: $command");

      // Execute FFmpeg command
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (returnCode != null && returnCode.isValueSuccess()) {
        final file = File(outputPath);
        if (file.existsSync()) {
          print("File created successfully at $outputPath");

          // Upload the chunk immediately after creation
          try {
            final multipartFile = await http.MultipartFile.fromPath(
              'audioChunk',
              file.path,
              contentType: MediaType('audio', 'wav'),
            );
            await uploadAndDelete(audioId, index + 1, chunkDurationSecs,
                totalChunks, multipartFile, file);
          } catch (e) {
            print("Error during upload: $e");
            throw e;
          }

          index++;
        } else {
          print("File doesn't exist at path: $outputPath");
          splitSuccess = false;
        }
      } else {
        print("FFmpeg execution failed or return code was not successful.");
        final failure = await session.getFailStackTrace();
        if (failure != null) {
          print("FFmpeg failure: $failure");
        }
        splitSuccess = false;
      }

      // Update progress
      if (mounted) {
        setState(() {
          _uploadProgress = index / totalChunks;
        });
      }

      // Stop when all chunks are processed
      if (index >= totalChunks) {
        splitSuccess = false;
      }
    }

    // Clean up temporary files
    try {
      final dir = Directory(tempDir.path);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
        print("Temporary directory cleared.");
      }
    } catch (e) {
      print("Error clearing temporary directory: $e");
    }
  }

  Future<void> uploadAndDelete(
      int audioId,
      int chunkNumber,
      int chunkDurationSecs,
      int totalChunks,
      http.MultipartFile multipartFile,
      File file) async {
    String s3FilePath = await widget.uploadRepository.uploadChunk(
      audioId,
      chunkNumber, // chunk number (1-based index)
      totalChunks,
      chunkDurationSecs,
      multipartFile,
    );

    print("Uploaded chunk to: $s3FilePath");
    file.delete(recursive: true);
    print("File Deleted: ${file.path}");
  }

  Future<File> cleanMetadata(File file) async {
    final tempDir = await getTemporaryDirectory();
    final outputFilePath =
        '${tempDir.path}/cleaned_${path.basename(file.path)}';

    await FFmpegKit.execute(
        '-i "${file.path}" -map_metadata -1 -c copy "$outputFilePath"');

    return File(outputFilePath);
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
      resizeToAvoidBottomInset: true,
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
                    child: _isLoading && _audioFile == null
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

            // Show progress
            if (_isLoading && _uploadProgress > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    const Text('Uploading...'),
                    LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.green,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${(_uploadProgress * 100).toStringAsFixed(0)}% completed',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),

            // Upload Audio Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _uploadAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isLoading ? Colors.grey : Colors.purple,
                    ),
                    child: _isLoading
                        ? const Text(
                            'Uploading...',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )
                        : const Text(
                            'Upload Audio',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
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
