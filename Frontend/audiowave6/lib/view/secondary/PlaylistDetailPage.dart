// view/PlaylistDetailPage.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../data/repositories/metadata_repository_impl.dart';
import '../../data/repositories/playlist_repository_impl.dart';
import '../../domain/entities/audio.dart';
import '../../domain/entities/playlist.dart';
import '../../services/audio_player_service.dart';
import '../../services/playlist_service.dart';
import '../Helpers/audio_list_item.dart';
import 'AudioPlayerPage.dart';

class PlaylistDetailPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailPage({Key? key, required this.playlist}) : super(key: key);

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final playlistService = PlaylistService(PlaylistRepositoryImpl(http.Client()));
  final audioRepository = MetadataRepositoryImpl(http.Client());

  late Future<List<Audio>> _audiosFuture;

  @override
  void initState() {
    super.initState();
    _audiosFuture = _fetchAudios();
  }

  Future<List<Audio>> _fetchAudios() async {
    List<Audio> audios = [];
    for (int audioId in widget.playlist.audioIds) {
      final audio = await audioRepository.getAudio(audioId);
      audios.add(audio);
    }
    return audios;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Remove GestureDetector to allow default drag-to-dismiss
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Rounded top corners
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Indicator
          Container(
            width: 40,
            height: 6,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Playlist Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  widget.playlist.playlistName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Created on: ${widget.playlist.creationDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Access Level: ${widget.playlist.accessLevel.key}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          // List of Audios
          Expanded(
            child: FutureBuilder<List<Audio>>(
              future: _audiosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Failed to load audios'));
                }

                final audios = snapshot.data ?? [];

                if (audios.isEmpty) {
                  return Center(child: Text('No audios in this playlist'));
                }

                return ListView.builder(
                  itemCount: audios.length,
                  itemBuilder: (context, index) {
                    final audio = audios[index];
                    return AudioListItem(
                      audio: audio,
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () async {
                          // Confirm removal
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Remove Audio'),
                              content: Text('Remove this audio from the playlist?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Remove'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await playlistService.removeAudioFromPlaylist(
                                widget.playlist.id,
                                audio.id,
                              );
                              setState(() {
                                _audiosFuture = _fetchAudios();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Audio removed from playlist')),
                              );
                            } catch (e) {
                              print('Error removing audio: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to remove audio')),
                              );
                            }
                          }
                        },
                      ),
                      onTap: () {
                          final audioPlayerService = AudioPlayerService();
                          audioPlayerService.playAudio(audio);

                          // Open AudioPlayerPage as a modal bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => FractionallySizedBox(
                              heightFactor: 0.95,
                              child: AudioPlayerPage(audio: audio),
                            ),
                          );
                        },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
