import '../../domain/entities/playlist.dart';
import '../../domain/entities/access_level.dart';

class PlaylistModel extends Playlist {
  PlaylistModel({
    required String id,
    required int userId,
    required String playlistName,
    required Set<int> audioIds,
    required DateTime creationDate,
    required DateTime updateDate,
    required AccessLevel accessLevel,
  }) : super(
          id: id,
          userId: userId,
          playlistName: playlistName,
          audioIds: audioIds,
          creationDate: creationDate,
          updateDate: updateDate,
          accessLevel: accessLevel,
        );

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'],
      userId: json['userId'],
      playlistName: json['playlistName'],
      audioIds: Set<int>.from(json['audioIds']),
      creationDate: DateTime.parse(json['creationDate']),
      updateDate: DateTime.parse(json['updateDate']),
      accessLevel: AccessLevel.values.firstWhere((e) => e.toString() == 'AccessLevel.${json['accessLevel']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'playlistName': playlistName,
      'audioIds': audioIds.toList(),
      'creationDate': creationDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
      'accessLevel': accessLevel.toString().split('.').last,
    };
  }
}
