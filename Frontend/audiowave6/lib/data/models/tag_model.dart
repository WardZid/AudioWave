import '../../domain/entities/tag.dart';

class TagModel extends Tag {
  TagModel({
    required int id,
    int? audioId,
    String? tag,
  }) : super(
          id: id,
          audioId: audioId,
          tag: tag,
        );

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      audioId: json['audioId'],
      tag: json['tag1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'audioId': audioId,
      'tag1': tag,
    };
  }
}
