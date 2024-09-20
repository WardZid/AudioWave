import 'package:audiowave6/data/api/endpoints.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/upload_repository.dart';
import '../../utils/storage_utils.dart';

class UploadRepositoryImpl implements UploadRepository {
  final http.Client client;

  static const String baseUrl = Endpoints.uploadAudioUrl;

  UploadRepositoryImpl(this.client);

  @override
  Future<String> uploadChunk(
    int audioId,
    int chunkNumber,
    int totalChunks,
    int chunkDurationSecs,
    http.MultipartFile audioChunk,
  ) async {
    String? token = await StorageUtils.getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/Chunk'),
    );

    request.fields['audioId'] = audioId.toString();
    request.fields['chunkNumber'] = chunkNumber.toString();
    request.fields['totalChunks'] = totalChunks.toString();
    request.fields['chunkDurationSecs'] = chunkDurationSecs.toString();

    request.files.add(audioChunk);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.send(request);

    if (response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to upload chunk');
    }
  }
}
