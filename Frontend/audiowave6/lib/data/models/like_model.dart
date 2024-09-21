
import '../../domain/entities/like.dart';

class LikeModel extends Like {
  LikeModel({
    required int userId,
    required int audioId,
    DateTime? likedAt,
  }) : super(
          userId: userId,
          audioId: audioId,
          likedAt: likedAt,
        );

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      userId: json['userId'],
      audioId: json['audioId'],
      likedAt: json['likedAt'] != null
          ? DateTime.parse(json['likedAt'])
          : null,
    );
  }
}