// data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required int id, required String email, required String username, required String firstName, required String lastName})
      : super(id: id, email: email, username: username, firstName: firstName, lastName: lastName);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserModel model = UserModel(
      id: json['userId'],
      email: json['email'] ?? "",
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
    print("made model");
    return model;
  }
}
