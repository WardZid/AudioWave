import 'package:http/http.dart' as http;

class UploadChunk {
  final int audioId;
  final int chunkNumber;
  final int totalChunks;
  final int chunkDurationSecs;
  final http.MultipartFile audioChunk;

  UploadChunk({
    required this.audioId,
    required this.chunkNumber,
    required this.totalChunks,
    required this.chunkDurationSecs,
    required this.audioChunk,
  });
}
