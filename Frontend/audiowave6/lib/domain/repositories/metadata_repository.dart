import '../entities/audio.dart';
import '../entities/listen.dart';
import '../entities/status.dart';
import '../entities/visibility.dart';

abstract class MetadataRepository {
  Future<Audio> getAudio(int id);
  Future<Audio> getAudioForListen(int id);
  Future<List<Audio>> getAllAudios();
  Future<List<Audio>> getAudiosByUser(int userId);
  Future<int> addAudio(Audio audio);
  Future<Audio> updateAudio(int id, Audio audio);
  Future<bool> deleteAudio(int id);
  Future<List<Status>> getStatuses();
  Future<List<Visibility>> getVisibilities();

  Future<List<Listen>> getUserListenHistory(int userId);
  Future<List<Listen>> getAudioListenHistory(int audioId);
}
