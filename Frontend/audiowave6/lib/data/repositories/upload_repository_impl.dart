import 'package:audiowave6/data/api/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/repositories/upload_repository.dart';

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
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/Chunk'),
    );

    request.fields['audioId'] = audioId.toString();
    request.fields['chunkNumber'] = chunkNumber.toString();
    request.fields['totalChunks'] = totalChunks.toString();
    request.fields['chunkDurationSecs'] = chunkDurationSecs.toString();

    request.files.add(audioChunk);

    final response = await client.send(request);

    if (response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to upload chunk');
    }
  }
}
