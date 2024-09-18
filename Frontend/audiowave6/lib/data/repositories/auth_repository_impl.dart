import 'package:audiowave6/data/models/user_model.dart';
import 'package:audiowave6/domain/entities/user.dart';
import 'package:audiowave6/utils/storage_utils.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import '../api/endpoints.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../utils/crypto_utils.dart';

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;

  AuthRepositoryImpl(this.client);

  static const String baseUrl = Endpoints.usersAuthUrl;

  @override
  Future<bool> isSignedIn() async {
    // get token from storage
    final token = await StorageUtils.getToken();
    if (token == null) {
      return false;
    }

    try {
      // check if jwt is expired
      bool isExpired = JwtDecoder.isExpired(token);
      return !isExpired;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> getPublicKey() async {
    print("DEV-LOG: Fetching public key");
    try {
      final response = await client.get(Uri.parse(Endpoints.publicKeyUrl));
      // print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load public key');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<bool> signIn(String email, String password) async {
    final publicKey = await getPublicKey();

    final dto = {
      "email": email,
      "password": password,
    };
    final dtoString = jsonEncode(dto);
    //final encryptedDto = encryptData(dtoString, publicKey);

    final response = await client.post(
      Uri.parse(Endpoints.loginUrl), //loginEncryptedUrl),
      headers: {'Content-Type': 'application/json'},
      body: dtoString, //jsonEncode(encryptedDto),
    );

    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        try {
          final token = jsonDecode(response.body)['token'];
          final userId = jsonDecode(response.body)['userId'];
          await StorageUtils.storeToken(token);
          await StorageUtils.storeUserId(userId.toString());
          return true;
        } catch (e) {
          print(e.toString());
          throw e;
        }
      case 401:
        throw Exception('Incorrect Credentials');
      default:
        throw Exception('Failed to Sign In');
    }
  }

  @override
  Future<void> signOut() async {
    await StorageUtils.deleteToken();
    await StorageUtils.deleteUserId();
  }

  @override
  Future<bool> register(String email, String username, String password,
      String firstName, String lastName) async {
    final publicKey = await getPublicKey();

    final dto = {
      "email": email,
      "username": username,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
    };
    final dtoString = jsonEncode(dto);
    // final encryptedDto = encryptData(dtoString, publicKey);

    final response = await client.post(
      Uri.parse(Endpoints.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: dtoString, //jsonEncode(encryptedDto),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> checkUsername(String username) async {
    final response = await client.post(
      Uri.parse(Endpoints.checkUsernameUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(username),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check username');
    }
  }

  @override
  Future<bool> checkEmail(String email) async {
    final response = await client.post(
      Uri.parse(Endpoints.checkEmailUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(email),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check email');
    }
  }

  @override
  Future<User> getUserInfo(int userId) async {
    String? token = await StorageUtils.getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/user-info?userId=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      try {
        var body = json.decode(response.body);
        // print(body);
        UserModel userModel = await UserModel.fromJson(body);
        // print(userModel);
        return userModel;
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print("AUTH REPO - Failed to load user");
      throw Exception('Failed to load user');
    }
  }
}
