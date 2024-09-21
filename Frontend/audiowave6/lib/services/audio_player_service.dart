// audio_player_service.dart
import 'package:audiowave6/domain/repositories/metadata_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:typed_data';
import 'package:rxdart/rxdart.dart';
import '../domain/entities/audio.dart';
import '../domain/repositories/playback_repository.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();

  factory AudioPlayerService() {
    return _instance;
  }

  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);
  Audio? _currentAudio;
  PlaybackRepository? _playbackRepository;
  MetadataRepository? _metadataRepository;

  int _currentChunkIndex = 1; // Start from 1 instead of 0
  late int _totalChunks;
  bool _isFetching = false;

  void initialize(PlaybackRepository playbackRepository,MetadataRepository metadataRepository) {
    _playbackRepository = playbackRepository;
    _metadataRepository = metadataRepository;
  }

  Future<void> playAudio(Audio audio) async {
    _currentAudio = audio;

    if (_playbackRepository == null) return;

    try {
      if(_metadataRepository != null){
        _metadataRepository?.getAudioForListen(audio.id);
      }
    } catch (e) {
      print("Couldnt fetch audio for listen");
    }

    // Reset state
    _playlist.clear();
    _currentChunkIndex = 1; // Start from 1
    _isFetching = false;

    // Calculate total number of chunks
    _totalChunks = ((audio.durationSec + 4) / 5).floor(); // Adjusted calculation

    // Start by fetching the first few chunks
    await _fetchAndAppendChunks(initialLoad: true);

    // Listen for when the player reaches near the end of the playlist to fetch more chunks
    _audioPlayer.sequenceStateStream.listen((sequenceState) async {
      if (sequenceState == null) return;

      // Fetch more chunks when there are less than 2 chunks left to play
      if (_playlist.length - (_audioPlayer.currentIndex ?? 0) <= 2 && !_isFetching) {
        _isFetching = true;
        await _fetchAndAppendChunks();
        _isFetching = false;
      }
    });

    // Set the playlist as the audio source
    await _audioPlayer.setAudioSource(_playlist);
    _audioPlayer.play();
  }

  Future<void> _fetchAndAppendChunks({int chunksToFetch = 5, bool initialLoad = false}) async {
    if (initialLoad) {
      chunksToFetch = 3; // Fetch first 3 chunks initially
    }

    while (_currentChunkIndex <= _totalChunks && chunksToFetch > 0) {
      try {
        Uint8List chunkData = await _playbackRepository!.getChunk(
          _currentAudio!.id,
          _currentChunkIndex,
        );

        // Create an AudioSource from the chunk data
        final audioUri = Uri.dataFromBytes(chunkData, mimeType: 'audio/wav');
        final audioSource = AudioSource.uri(audioUri);

        _playlist.add(audioSource);

        _currentChunkIndex++;
        chunksToFetch--;
      } catch (e) {
        print('Error fetching chunk $_currentChunkIndex: $e');
        break;
      }
    }
  }

  void pause() => _audioPlayer.pause();

  void resume() => _audioPlayer.play();

  void stop() => _audioPlayer.stop();

  /// Adjusted seek method to handle seeking across chunks
  Future<void> seek(Duration position) async {
    int targetChunkIndex = (position.inSeconds ~/ 5) + 1; // Adjusted for 1-based indexing
    Duration positionInChunk = position - Duration(seconds: (targetChunkIndex - 1) * 5);

    // Ensure the target chunk is loaded
    if (targetChunkIndex > _playlist.length) {
      // Fetch chunks up to targetChunkIndex
      while (_currentChunkIndex <= targetChunkIndex && _currentChunkIndex <= _totalChunks) {
        await _fetchAndAppendChunks(chunksToFetch: 1);
      }
    }

    if (targetChunkIndex <= _playlist.length) {
      await _audioPlayer.seek(positionInChunk, index: targetChunkIndex - 1);
    } else {
      print('Target chunk index $targetChunkIndex is not available.');
    }
  }

  void seekRelative(int seconds) {
    final newPosition = currentPosition + Duration(seconds: seconds);
    seek(newPosition);
  }

  /// Stream that provides cumulative position across all chunks
  Stream<Duration> get positionStream => Rx.combineLatest2<int?, Duration, Duration>(
        _audioPlayer.currentIndexStream,
        _audioPlayer.positionStream,
        (currentIndex, position) {
          if (currentIndex == null) return Duration.zero;
          return Duration(seconds: (currentIndex) * 5) + position;
        },
      );

  Duration get currentPosition {
    int currentIndex = _audioPlayer.currentIndex ?? 0;
    Duration positionInChunk = _audioPlayer.position;
    return Duration(seconds: (currentIndex) * 5) + positionInChunk;
  }

  /// Expose total duration from the Audio object
  Duration get totalDuration => Duration(seconds: _currentAudio?.durationSec ?? 0);

  Audio? get currentAudio => _currentAudio;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
}
