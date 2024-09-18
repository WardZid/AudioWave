class Audio {
  final int id;
  final String? title;
  final String? description;
  final List<int>? thumbnail;
  final int durationSec;
  final int? fileSize;
  final String? fileType;
  final List<int>? fileChecksum;
  final int? listens;
  final int? statusId;
  final int visibilityId;
  final DateTime? uploadedAt;
  final int? uploaderId;

  Audio({
    required this.id,
    this.title,
    this.description,
    this.thumbnail,
    required this.durationSec,
    this.fileSize,
    this.fileType,
    this.fileChecksum,
    this.listens,
    this.statusId,
    required this.visibilityId,
    this.uploadedAt,
    this.uploaderId,
  });
}
