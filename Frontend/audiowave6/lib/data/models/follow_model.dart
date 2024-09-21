
import '../../domain/entities/follow.dart';

class FollowModel extends Follow {
  FollowModel({
    required int followerId,
    required int followedId,
    DateTime? followedAt,
  }) : super(
          followerId: followerId,
          followedId: followedId,
          followedAt: followedAt,
        );

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      followerId: json['followerId'],
      followedId: json['followedId'],
      followedAt: json['followedAt'] != null
          ? DateTime.parse(json['followedAt'])
          : null,
    );
  }
}
