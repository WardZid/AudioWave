import 'dart:typed_data';

class Audio {
  final int id;
  final String? title;
  final String? description;
  final Uint8List? thumbnail;
  final int durationSec;
  final int? fileSize;
  final String? fileType;
  final Uint8List? fileChecksum;
  final int? listens;
  final int? statusId;
  final int visibilityId;
  final DateTime? uploadedAt;
  final int? uploaderId;
  final List<String>? tags;

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
    this.tags,
  });
}
