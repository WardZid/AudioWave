class Follow {
  final int followerId;
  final int followedId;
  final DateTime? followedAt;

  Follow({
    required this.followerId,
    required this.followedId,
    this.followedAt,
  });
}
