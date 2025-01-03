// audio_player_page.dart

import 'package:flutter/material.dart';
import '../../data/repositories/like_repository_impl.dart';
import '../../data/repositories/playlist_repository_impl.dart';
import '../../domain/entities/audio.dart';
import '../../domain/entities/playlist.dart';
import '../../services/audio_player_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

import '../../services/playlist_service.dart';
import '../Helpers/create_playlist_dialog.dart';

class AudioPlayerPage extends StatefulWidget {
  final Audio audio;

  const AudioPlayerPage({Key? key, required this.audio}) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final audioPlayerService = AudioPlayerService();
  final likeRepository = LikeRepositoryImpl(http.Client());
  late Stream<DurationState> _durationStateStream;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    // Use the cumulative position stream and total duration from the audioPlayerService
    _durationStateStream = audioPlayerService.positionStream.map(
      (position) => DurationState(position, audioPlayerService.totalDuration),
    );

    // Start playing the audio if it's not already playing
    if (audioPlayerService.currentAudio?.id != widget.audio.id) {
      audioPlayerService.playAudio(widget.audio);
    }
  }

  Future<void> _checkIfLiked() async {
    try {
      bool liked = await likeRepository.isLiked(widget.audio.id);
      setState(() {
        isLiked = liked;
      });
    } catch (e) {
      print('Error checking if liked: $e');
    }
  }

  Future<void> _toggleLike() async {
    try {
      if (isLiked) {
        await likeRepository.removeLike(widget.audio.id);
      } else {
        await likeRepository.addLike(widget.audio.id);
      }
      setState(() {
        isLiked = !isLiked;
      });
    } catch (e) {
      print('Error toggling like: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update like status')),
      );
    }
  }

  // Helper method to format duration in mm:ss
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Get the audio duration
    final totalDuration = Duration(seconds: widget.audio.durationSec);

    return Scaffold(
      backgroundColor: Colors.transparent, // Set background to transparent
      body: Stack(
        children: [
          // Background color
          Container(
            color: Colors.transparent,
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25), // Rounded top corners
                    ),
                  ),
                  child: Column(
                    children: [
                      // Display the thumbnail
                      Expanded(
                        child: widget.audio.thumbnail != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                ),
                                child: Image.memory(
                                  widget.audio.thumbnail!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
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
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
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
                            const SizedBox(height: 8),
                            // Listens/Views count
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.visibility,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.audio.listens ?? 0} waves',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Progress bar
                            StreamBuilder<DurationState>(
                              stream: _durationStateStream,
                              builder: (context, snapshot) {
                                final durationState = snapshot.data;
                                final position =
                                    durationState?.position ?? Duration.zero;
                                final total =
                                    durationState?.total ?? totalDuration;

                                return Column(
                                  children: [
                                    Slider(
                                      min: 0.0,
                                      max: total.inMilliseconds.toDouble(),
                                      value: position.inMilliseconds
                                          .clamp(0, total.inMilliseconds)
                                          .toDouble(),
                                      onChanged: (value) {
                                        audioPlayerService.seek(
                                          Duration(milliseconds: value.toInt()),
                                        );
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                    audioPlayerService
                                        .seekRelative(-10); // Skip back 10 seconds
                                  },
                                ),
                                StreamBuilder<PlayerState>(
                                  stream: audioPlayerService.playerStateStream,
                                  builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                    final isPlaying =
                                        playerState?.playing ?? false;
                                    return IconButton(
                                      iconSize: 64,
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_fill,
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
                                    audioPlayerService
                                        .seekRelative(10); // Skip forward 10 seconds
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
                                  icon: Icon(isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                  color: isLiked ? Colors.red : Colors.black,
                                  onPressed: _toggleLike,
                                ),
                                const SizedBox(width: 32),
                                IconButton(
                                  iconSize: 32,
                                  icon: const Icon(Icons.playlist_add),
                                  onPressed: () {
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddToPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final playlistService =
            PlaylistService(PlaylistRepositoryImpl(http.Client()));
        return FutureBuilder<List<Playlist>>(
          future: playlistService.getUserPlaylists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to load playlists'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              );
            }

            final playlists = snapshot.data ?? [];

            return AlertDialog(
              title: Text('Add to Playlist'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Create New Playlist'),
                      onTap: () async {
                        Navigator.pop(context); // Close the current dialog
                        final result = await showDialog(
                          context: context,
                          builder: (context) => CreatePlaylistDialog(
                            playlistService: playlistService,
                          ),
                        );
                        if (result == true) {
                          // Refresh playlists or show success message
                        }
                      },
                    ),
                    ...playlists.map((playlist) {
                      return ListTile(
                        title: Text(playlist.playlistName),
                        onTap: () async {
                          try {
                            await playlistService.addAudioToPlaylist(
                              playlist.id,
                              widget.audio.id,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Added to ${playlist.playlistName}')),
                            );
                          } catch (e) {
                            // Handle error
                            print('Error adding to playlist: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to add to playlist')),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
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
