import 'package:audiowave6/data/api/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import '../../domain/repositories/playback_repository.dart';
import '../../utils/storage_utils.dart';

class PlaybackRepositoryImpl implements PlaybackRepository {
  final http.Client client;
  static const String baseUrl = Endpoints.playbackAudioUrl;

  PlaybackRepositoryImpl(this.client);

  @override
  Future<Uint8List> getChunk(int audioId, int chunkNumber) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/Chunk?AudioId=$audioId&ChunkNumber=$chunkNumber'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // Return the chunk as bytes
    } else {
      throw Exception('Failed to retrieve audio chunk');
    }
  }

  @override
  Future<Uint8List> getCombinedChunks(int audioId, int firstChunkNumber, int lastChunkNumber) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/CombinedChunks?AudioId=$audioId&FirstChunkNumber=$firstChunkNumber&LastChunkNumber=$lastChunkNumber'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // Return the combined chunks as bytes
    } else {
      throw Exception('Failed to retrieve combined audio chunks');
    }
  }
}
