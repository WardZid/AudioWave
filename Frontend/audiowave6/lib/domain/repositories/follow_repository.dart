import '../entities/follow.dart';

abstract class FollowRepository {
  Future<void> addFollow(int followeeId);
  Future<void> removeFollow(int followeeId);
  Future<void> removeFollower(int followerId);
  Future<List<Follow>> getFollowers();
  Future<List<Follow>> getFollowing();
}
