import 'package:http/http.dart' as http;

abstract class UploadRepository {
  Future<String> uploadChunk(
    int audioId,
    int chunkNumber,
    int totalChunks,
    int chunkDurationSecs,
    http.MultipartFile audioChunk,
  );
}
