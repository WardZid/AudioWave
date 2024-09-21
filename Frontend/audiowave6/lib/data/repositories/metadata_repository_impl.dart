import 'package:audiowave6/data/api/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/audio.dart';
import '../../domain/entities/listen.dart';
import '../../domain/entities/status.dart';
import '../../domain/entities/visibility.dart';
import '../../domain/repositories/metadata_repository.dart';
import '../../utils/storage_utils.dart';
import '../models/audio_model.dart';
import '../models/listen_model.dart';
import '../models/status_model.dart';
import '../models/visibility_model.dart';

class MetadataRepositoryImpl implements MetadataRepository {
  final http.Client client;

  MetadataRepositoryImpl(this.client);

  static const String baseUrl = Endpoints.audioMetadataUrl;

  @override
  Future<Audio> getAudio(int id) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AudioModel.fromJson(data); // Convert to AudioModel
    } else {
      throw Exception('Failed to load audio');
    }
  }

  @override
  Future<Audio> getAudioForListen(int id) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/GetAudioForListen/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AudioModel.fromJson(data);
    } else {
      throw Exception('Failed to load audio for listening');
    }
  }

  @override
  Future<List<Audio>> getAllAudios() async {
    final response = await client.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((audio) => AudioModel.fromJson(audio)).toList();
    } else {
      throw Exception('Failed to load audios');
    }
  }

  @override
  Future<List<Audio>> getAudiosByUser(int userId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/GetAudiosByUser?uploaderId=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((audio) => AudioModel.fromJson(audio)).toList();
    } else {
      throw Exception('Failed to load audios');
    }
  }

  @override
  Future<int> addAudio(Audio audio) async {
    String? token = await StorageUtils.getToken();
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': audio.title,
        'description': audio.description,
        'thumbnail':audio.thumbnail != null ? base64Encode(audio.thumbnail!) : null,
        'durationSec': audio.durationSec,
        'fileSize': audio.fileSize,
        'fileType': audio.fileType,
        'fileChecksum': audio.fileChecksum != null ? base64Encode(audio.fileChecksum!) : null,
        'visibilityId': audio.visibilityId,
        'tags': audio.tags
      }),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data;
    } else {
      print("Failed to add audio: " + response.body);
      throw Exception("Failed to add audio: " + response.body);
    }
  }

  @override
  Future<Audio> updateAudio(int id, Audio audio) async {
    String? token = await StorageUtils.getToken();
    final response = await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'id': id,
        'title': audio.title,
        'description': audio.description,
        'thumbnail': audio.thumbnail,
        'durationSec': audio.durationSec,
        'fileSize': audio.fileSize,
        'fileType': audio.fileType,
        'fileChecksum': audio.fileChecksum,
        'visibilityId': audio.visibilityId,
        'uploaderId': audio.uploaderId,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AudioModel.fromJson(data);
    } else {
      throw Exception('Failed to update audio');
    }
  }

  @override
  Future<bool> deleteAudio(int id) async {
    String? token = await StorageUtils.getToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete audio');
    }
  }

  @override
  Future<List<Status>> getStatuses() async {
    final response = await client.get(Uri.parse('$baseUrl/GetStatuses'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((status) => StatusModel.fromJson(status)).toList();
    } else {
      throw Exception('Failed to load statuses');
    }
  }

  @override
  Future<List<Visibility>> getVisibilities() async {
    final response = await client.get(Uri.parse('$baseUrl/GetVisibilities'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data
          .map((visibility) => VisibilityModel.fromJson(visibility))
          .toList();
    } else {
      throw Exception('Failed to load visibilities');
    }
  }
  @override
  Future<List<Listen>> getUserListenHistory(int userId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/UserListenHistory?userId=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => ListenModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load user listen history');
    }
  }

  @override
  Future<List<Listen>> getAudioListenHistory(int audioId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/AudioListenHistory?audioId=$audioId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => ListenModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load audio listen history');
    }
  }
}
