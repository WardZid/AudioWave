import 'dart:typed_data';

class AddAudioDto {
  String? title;
  String description = "";
  Uint8List? thumbnail;
  int durationSec;
  int? fileSize;
  String? fileType;
  Uint8List? fileChecksum;
  int? visibilityId;
  List<String>? tags;

  AddAudioDto({
    this.title,
    this.description = "",
    this.thumbnail,
    required this.durationSec,
    this.fileSize,
    this.fileType,
    this.fileChecksum,
    this.visibilityId,
    this.tags,
  });
}
