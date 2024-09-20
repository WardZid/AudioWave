import 'package:audiowave6/data/api/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/storage_utils.dart';
import '../models/playlist_model.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/access_level.dart';
import '../../domain/repositories/playlist_repository.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final http.Client client;
  static const String baseUrl = Endpoints.playlistUrl;

  PlaylistRepositoryImpl(this.client);

  @override
  Future<List<Playlist>> getAll() async {
    final response = await client.get(Uri.parse('$baseUrl/GetAll'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((playlist) => PlaylistModel.fromJson(playlist)).toList();
    } else {
      throw Exception('Failed to load playlists');
    }
  }

  @override
  Future<Playlist> getById(String id) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/GetById?id=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      );
    if (response.statusCode == 200) {
      return PlaylistModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load playlist');
    }
  }

  @override
  Future<List<Playlist>> getByUploaderId(int uploaderId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/GetByUploader?UploaderId=$uploaderId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((playlist) => PlaylistModel.fromJson(playlist)).toList();
    } else {
      throw Exception('Failed to load playlist by uploader');
    }
  }

  @override
Future<String> createPlaylist(Playlist playlist) async {
  String? token = await StorageUtils.getToken();
  final response = await client.post(
    Uri.parse('$baseUrl/AddPlaylist'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'playlistName': playlist.playlistName,
      'audioIds': playlist.audioIds.toList(),
      'accessLevel': playlist.accessLevel.value,
    }),
  );
  if (response.statusCode == 201) {
    return json.decode(response.body)['id'];
  } else {
    throw Exception('Failed to create playlist ${response.body}');
  }
}

  @override
Future<void> updatePlaylist(Playlist playlist) async {
  String? token = await StorageUtils.getToken();
  final response = await client.put(
    Uri.parse('$baseUrl/UpdatePlaylist'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'playlistId': playlist.id,
      'playlistName': playlist.playlistName,
      'accessLevel': playlist.accessLevel.value,
    }),
  );
  if (response.statusCode != 204) {
    throw Exception('Failed to update playlist');
  }
}

  @override
  Future<void> deletePlaylist(String playlistId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/DeletePlaylist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'playlistId': playlistId}),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete playlist');
    }
  }

  @override
  Future<void> addAudioToPlaylist(String playlistId, List<int> audioIds) async {
    String? token = await StorageUtils.getToken();
    final response = await client.post(
      Uri.parse('$baseUrl/AddAudio'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'playlistId': playlistId,
        'audioIds': audioIds,
      }),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to add audio to playlist');
    }
  }

  @override
  Future<void> removeAudioFromPlaylist(String playlistId, List<int> audioIds) async {
    String? token = await StorageUtils.getToken();
    final response = await client.post(
      Uri.parse('$baseUrl/RemoveAudio'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'playlistId': playlistId,
        'audioIds': audioIds,
      }),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to remove audio from playlist');
    }
  }

  @override
  Future<List<AccessLevel>> getAccessLevels() async {
    final response = await client.post(Uri.parse('$baseUrl/AccessLevels'));
    if (response.statusCode == 200) {
      
      final data = json.decode(response.body) as List;
      return data.map((level) => AccessLevel.fromJson(level)).toList();
    } else {
      throw Exception('Failed to load access levels');
    }
  }
}

