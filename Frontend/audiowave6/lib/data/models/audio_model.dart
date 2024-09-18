import '../../domain/entities/audio.dart';

class AudioModel extends Audio {
  AudioModel({
    required int id,
    String? title,
    String? description,
    List<int>? thumbnail,
    required int durationSec,
    int? fileSize,
    String? fileType,
    List<int>? fileChecksum,
    int? listens,
    int? statusId,
    required int visibilityId,
    DateTime? uploadedAt,
    int? uploaderId,
  }) : super(
          id: id,
          title: title,
          description: description,
          thumbnail: thumbnail,
          durationSec: durationSec,
          fileSize: fileSize,
          fileType: fileType,
          fileChecksum: fileChecksum,
          listens: listens,
          statusId: statusId,
          visibilityId: visibilityId,
          uploadedAt: uploadedAt,
          uploaderId: uploaderId,
        );

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'] != null ? List<int>.from(json['thumbnail']) : null,
      durationSec: json['durationSec'],
      fileSize: json['fileSize'],
      fileType: json['fileType'],
      fileChecksum: json['fileChecksum'] != null ? List<int>.from(json['fileChecksum']) : null,
      listens: json['listens'],
      statusId: json['statusId'],
      visibilityId: json['visibilityId'],
      uploadedAt: json['uploadedAt'] != null ? DateTime.parse(json['uploadedAt']) : null,
      uploaderId: json['uploaderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'durationSec': durationSec,
      'fileSize': fileSize,
      'fileType': fileType,
      'fileChecksum': fileChecksum,
      'listens': listens,
      'statusId': statusId,
      'visibilityId': visibilityId,
      'uploadedAt': uploadedAt?.toIso8601String(),
      'uploaderId': uploaderId,
    };
  }
}
