import '../entities/like.dart';

abstract class LikeRepository {
  Future<void> addLike(int audioId);
  Future<void> removeLike(int audioId);
  Future<List<Like>> getAllLikes();
  Future<bool> isLiked(int audioId);
}