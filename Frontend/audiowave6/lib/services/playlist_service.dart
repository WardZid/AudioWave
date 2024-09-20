// services/playlist_service.dart

import 'package:audiowave6/utils/storage_utils.dart';

import '../domain/entities/playlist.dart';
import '../domain/repositories/playlist_repository.dart';
import '../domain/entities/access_level.dart';

class PlaylistService {
  final PlaylistRepository _playlistRepository;

  PlaylistService(this._playlistRepository);

  Future<List<Playlist>> getUserPlaylists() async {
    
    int currentUserId = await _getCurrentUserId();
    return _playlistRepository.getByUploaderId(currentUserId);
  }

  Future<String> createPlaylist(String name, AccessLevel accessLevel) async {
    Playlist newPlaylist = Playlist(
      id: '', 
      userId: await _getCurrentUserId(),
      playlistName: name,
      audioIds: {},
      creationDate: DateTime.now(),
      updateDate: DateTime.now(),
      accessLevel: accessLevel,
    );
    return _playlistRepository.createPlaylist(newPlaylist);
  }

  Future<void> addAudioToPlaylist(String playlistId, int audioId) async {
    await _playlistRepository.addAudioToPlaylist(playlistId, [audioId]);
  }

  Future<void> removeAudioFromPlaylist(String playlistId, int audioId) async {
    await _playlistRepository.removeAudioFromPlaylist(playlistId, [audioId]);
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _playlistRepository.deletePlaylist(playlistId);
  }

  Future<List<AccessLevel>> getAccessLevels() async {
    return await _playlistRepository.getAccessLevels();
  }
  Future<int> _getCurrentUserId() async {
    return int.parse((await StorageUtils.getUserId()) ?? "-1");
  }
}
