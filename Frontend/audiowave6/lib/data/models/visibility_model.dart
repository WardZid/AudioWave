import '../../domain/entities/visibility.dart';

class VisibilityModel extends Visibility {
  VisibilityModel({
    required int id,
    required String visibility,
    String? description,
  }) : super(
          id: id,
          visibility: visibility,
          description: description,
        );

  factory VisibilityModel.fromJson(Map<String, dynamic> json) {
    return VisibilityModel(
      id: json['id'],
      visibility: json['visibility1'], // visibility1 is in the original C# class
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visibility1': visibility,
      'description': description,
    };
  }
}
