import '../entities/audio.dart';
import '../entities/status.dart';
import '../entities/visibility.dart';

abstract class MetadataRepository {
  Future<Audio> getAudio(int id);
  Future<Audio> getAudioForListen(int id);
  Future<List<Audio>> getAllAudios();
  Future<int> addAudio(Audio audio);
  Future<Audio> updateAudio(int id, Audio audio);
  Future<bool> deleteAudio(int id);
  Future<List<Status>> getStatuses();
  Future<List<Visibility>> getVisibilities();
}
