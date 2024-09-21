import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/like.dart';
import '../../domain/repositories/like_repository.dart';
import '../../utils/storage_utils.dart';
import '../api/endpoints.dart';
import '../models/like_model.dart';

class LikeRepositoryImpl implements LikeRepository {
  final http.Client client;

  LikeRepositoryImpl(this.client);

  static const String baseUrl = Endpoints.likesUrl;

  @override
  Future<void> addLike(int audioId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.post(
      Uri.parse('$baseUrl/AddLike'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'audioId': "$audioId",
      }
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add like');
    }
  }

  @override
  Future<void> removeLike(int audioId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/RemoveLike'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'audioId': "$audioId",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove like');
    }
  }

  @override
  Future<List<Like>> getAllLikes() async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/GetAll'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => LikeModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load likes');
    }
  }
  
  @override
  Future<bool> isLiked(int audioId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/IsLiked?audioId=$audioId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data as bool;
    } else {
      throw Exception('Failed to determine if liked');
    }
  }
}
