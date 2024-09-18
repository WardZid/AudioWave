import 'access_level.dart';

class Playlist {
  final String id;
  final int userId;
  final String playlistName;
  final Set<int> audioIds;
  final DateTime creationDate;
  final DateTime updateDate;
  final AccessLevel accessLevel;

  Playlist({
    required this.id,
    required this.userId,
    required this.playlistName,
    required this.audioIds,
    required this.creationDate,
    required this.updateDate,
    required this.accessLevel,
  });
}
