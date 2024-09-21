class Listen {
  final int id;
  final int? audioId;
  final int? userId;
  final DateTime? listenedAt;

  Listen({
    required this.id,
    this.audioId,
    this.userId,
    this.listenedAt
  });
}
