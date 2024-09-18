import '../../domain/entities/status.dart';

class StatusModel extends Status {
  StatusModel({
    required int id,
    required String status,
    String? description,
  }) : super(
          id: id,
          status: status,
          description: description,
        );

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      status: json['status1'], // status1 is in the original C# class
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status1': status,
      'description': description,
    };
  }
}
