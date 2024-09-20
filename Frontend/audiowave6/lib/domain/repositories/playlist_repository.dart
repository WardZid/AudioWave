import '../entities/playlist.dart';
import '../entities/access_level.dart';

abstract class PlaylistRepository {
  Future<List<Playlist>> getAll();
  Future<Playlist> getById(String id);
  Future<List<Playlist>> getByUploaderId(int uploaderId);
  Future<String> createPlaylist(Playlist playlist);
  Future<void> updatePlaylist(Playlist playlist);
  Future<void> deletePlaylist(String playlistId);
  Future<void> addAudioToPlaylist(String playlistId, List<int> audioIds);
  Future<void> removeAudioFromPlaylist(String playlistId, List<int> audioIds);
  Future<List<AccessLevel>> getAccessLevels();
}
