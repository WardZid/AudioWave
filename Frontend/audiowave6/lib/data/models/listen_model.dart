import 'package:audiowave6/domain/entities/listen.dart';

class ListenModel extends Listen {
  ListenModel({
    required int id,
    int? audioId,
    int? userId,
    DateTime? listenedAt,
  }): super(
          id: id,
          audioId: audioId,
          userId: userId,
          listenedAt: listenedAt
        );

  factory ListenModel.fromJson(Map<String, dynamic> json) {
    return ListenModel(
      id: json['id'],
      audioId: json['audioId'],
      userId: json['userId'],
      listenedAt: json['listenedAt'] != null
          ? DateTime.parse(json['listenedAt'])
          : null,
    );
  }
}
