import 'dart:convert';
import 'dart:typed_data';
import '../../domain/entities/audio.dart';

class AudioModel extends Audio {
  AudioModel({
    required int id,
    String? title,
    String? description,
    Uint8List? thumbnail, // Use Uint8List for byte arrays
    required int durationSec,
    int? fileSize,
    String? fileType,
    Uint8List? fileChecksum, // Use Uint8List for byte arrays
    int? listens,
    int? statusId,
    required int visibilityId,
    DateTime? uploadedAt,
    int? uploaderId,
  }) : super(
          id: id,
          title: title,
          description: description,
          thumbnail: thumbnail, // Thumbnail as a byte array (Uint8List)
          durationSec: durationSec,
          fileSize: fileSize,
          fileType: fileType,
          fileChecksum: fileChecksum, // File checksum as a byte array (Uint8List)
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
      thumbnail: json['thumbnail'] != null ? Uint8List.fromList(List<int>.from(jsonDecode(json['thumbnail']))) : null, // Convert thumbnail to Uint8List
      durationSec: json['durationSec'],
      fileSize: json['fileSize'],
      fileType: json['fileType'],
      //fileChecksum: json['fileChecksum'] != null ? Uint8List.fromList(List<int>.from(json['fileChecksum'])) : null, // Convert checksum to Uint8List
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
      'thumbnail': thumbnail?.toList(), // Convert Uint8List back to List<int>
      'durationSec': durationSec,
      'fileSize': fileSize,
      'fileType': fileType,
      'fileChecksum': fileChecksum?.toList(), // Convert Uint8List back to List<int>
      'listens': listens,
      'statusId': statusId,
      'visibilityId': visibilityId,
      'uploadedAt': uploadedAt?.toIso8601String(),
      'uploaderId': uploaderId,
    };
  }
}
