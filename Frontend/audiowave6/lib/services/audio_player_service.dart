// audio_player_service.dart
import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';
import '../domain/entities/audio.dart';
import '../domain/repositories/playback_repository.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();

  factory AudioPlayerService() {
    return _instance;
  }

  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);
  Audio? _currentAudio;
  PlaybackRepository? _playbackRepository;

  int _currentChunkIndex = 0;
  int _totalChunks = 0;
  bool _isFetching = false;

  void initialize(PlaybackRepository playbackRepository) {
    _playbackRepository = playbackRepository;
  }

  Future<void> playAudio(Audio audio) async {
    _currentAudio = audio;

    if (_playbackRepository == null) return;

    // Reset state
    _playlist.clear();
    _currentChunkIndex = 1;
    _isFetching = false;

    // Calculate total number of chunks
    _totalChunks = (audio.durationSec / 5).ceil();

    // Start by fetching the first few chunks
    await _fetchAndAppendChunks(initialLoad: true);

    // Listen for when the player reaches near the end of the playlist to fetch more chunks
    _audioPlayer.sequenceStateStream.listen((sequenceState) async {
      if (sequenceState == null) return;

      // Fetch more chunks when there are less than 2 chunks left to play
      if (_playlist.length - _audioPlayer.currentIndex! <= 2 && !_isFetching) {
        _isFetching = true;
        await _fetchAndAppendChunks();
        _isFetching = false;
      }
    });

    // Set the playlist as the audio source
    await _audioPlayer.setAudioSource(_playlist);
    _audioPlayer.play();
  }

  Future<void> _fetchAndAppendChunks({bool initialLoad = false}) async {
    // Fetch 5 chunks at a time or remaining chunks
    int chunksToFetch = 5;
    if (initialLoad) {
      chunksToFetch = 3; // Fetch first 3 chunks initially
    }

    while (_currentChunkIndex < _totalChunks && chunksToFetch > 0) {
      try {
        Uint8List chunkData = await _playbackRepository!.getChunk(
          _currentAudio!.id,
          _currentChunkIndex,
        );

        // Create an AudioSource from the chunk data
        final audioUri = Uri.dataFromBytes(chunkData, mimeType: 'audio/wav');
        final audioSource = AudioSource.uri(audioUri);

        // Append the chunk to the playlist
        _playlist.add(audioSource);

        _currentChunkIndex++;
        chunksToFetch--;
      } catch (e) {
        print('Error fetching chunk $_currentChunkIndex: $e');
        // Handle error (e.g., retry logic or break)
        break;
      }
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void seekRelative(int seconds) {
    final newPosition = _audioPlayer.position + Duration(seconds: seconds);
    _audioPlayer.seek(newPosition);
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  void pause() => _audioPlayer.pause();

  void resume() => _audioPlayer.play();

  void stop() => _audioPlayer.stop();

  Audio? get currentAudio => _currentAudio;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
}
