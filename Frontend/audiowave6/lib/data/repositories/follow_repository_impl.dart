import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/follow.dart';
import '../../domain/repositories/follow_repository.dart';
import '../../utils/storage_utils.dart';
import '../api/endpoints.dart';
import '../models/follow_model.dart';

class FollowRepositoryImpl implements FollowRepository {
  final http.Client client;

  FollowRepositoryImpl(this.client);

  static const String baseUrl = Endpoints.followUrl;

  @override
  Future<void> addFollow(int followeeId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.post(
      Uri.parse('$baseUrl/AddFollow'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'followeeId': followeeId,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to follow user');
    }
  }

  @override
  Future<void> removeFollow(int followeeId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/RemoveFollow'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'followeeId': followeeId,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to unfollow user');
    }
  }

  @override
  Future<void> removeFollower(int followerId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/RemoveFollower'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'followerId': followerId,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove follower');
    }
  }

  @override
  Future<List<Follow>> getFollowers() async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/GetFollowers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => FollowModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load followers');
    }
  }

  @override
  Future<List<Follow>> getFollowing() async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/GetFollowing'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => FollowModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load following');
    }
  }
}
