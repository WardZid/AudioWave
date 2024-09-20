// audio_player_page.dart

import 'package:flutter/material.dart';
import '../../domain/entities/audio.dart';
import '../../services/audio_player_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerPage extends StatefulWidget {
  final Audio audio;

  const AudioPlayerPage({Key? key, required this.audio}) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final audioPlayerService = AudioPlayerService();
  late Stream<DurationState> _durationStateStream;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();

    // Use the cumulative position stream and total duration from the audioPlayerService
    _durationStateStream = audioPlayerService.positionStream.map(
      (position) => DurationState(position, audioPlayerService.totalDuration),
    );

    // Start playing the audio if it's not already playing
    if (audioPlayerService.currentAudio?.id != widget.audio.id) {
      audioPlayerService.playAudio(widget.audio);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the audio duration
    final totalDuration = Duration(seconds: widget.audio.durationSec);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audio.title ?? 'Audio Player'),
      ),
      body: Column(
        children: [
          // Display the thumbnail
          Expanded(
            child: widget.audio.thumbnail != null
                ? Image.memory(
                    widget.audio.thumbnail!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    child: Icon(
                      Icons.music_note,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
          ),
          // Playback controls and info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Audio title
                Text(
                  widget.audio.title ?? 'Unknown Title',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Audio description
                if (widget.audio.description != null)
                  Text(
                    widget.audio.description!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),
                // Progress bar
                StreamBuilder<DurationState>(
                  stream: _durationStateStream,
                  builder: (context, snapshot) {
                    final durationState = snapshot.data;
                    final position = durationState?.position ?? Duration.zero;
                    final total = durationState?.total ?? totalDuration;

                    return Column(
                      children: [
                        Slider(
                          min: 0.0,
                          max: total.inMilliseconds.toDouble(),
                          value: position.inMilliseconds.clamp(0, total.inMilliseconds).toDouble(),
                          onChanged: (value) {
                            audioPlayerService.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(total)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Playback controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        audioPlayerService.seekRelative(-10); // Skip back 10 seconds
                      },
                    ),
                    StreamBuilder<PlayerState>(
                      stream: audioPlayerService.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final isPlaying = playerState?.playing ?? false;
                        return IconButton(
                          iconSize: 64,
                          icon: Icon(
                            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              audioPlayerService.pause();
                            } else {
                              audioPlayerService.resume();
                            }
                          },
                        );
                      },
                    ),
                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        audioPlayerService.seekRelative(10); // Skip forward 10 seconds
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Like and Add to Playlist buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 32,
                      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                      color: isLiked ? Colors.red : Colors.black,
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                        // TODO: Handle like action (e.g., update database or call API)
                      },
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      iconSize: 32,
                      icon: const Icon(Icons.playlist_add),
                      onPressed: () {
                        // TODO: Handle add to playlist action
                        _showAddToPlaylistDialog();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format duration in mm:ss
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Method to show add to playlist dialog
  void _showAddToPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Replace with your own logic to fetch and display playlists
        final playlists = ['Playlist 1', 'Playlist 2', 'Create New Playlist'];

        return AlertDialog(
          title: const Text('Add to Playlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(playlists[index]),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Handle adding the audio to the selected playlist
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Helper class to hold position and total duration
class DurationState {
  final Duration position;
  final Duration total;

  DurationState(this.position, this.total);
}
