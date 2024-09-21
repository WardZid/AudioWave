class Like {
  final int userId;
  final int audioId;
  final DateTime? likedAt;

  Like({
    required this.userId,
    required this.audioId,
    this.likedAt,
  });
}
