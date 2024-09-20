// view/PlaylistDetailPage.dart

import 'package:audiowave6/data/repositories/metadata_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/repositories/playlist_repository_impl.dart';
import '../../domain/entities/audio.dart';
import '../../domain/entities/playlist.dart';
import '../../services/playlist_service.dart';

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
    // Fetch audio details for the audio IDs in the playlist
    List<Audio> audios = [];
    for (int audioId in widget.playlist.audioIds) {
      final audio = await audioRepository.getAudio(audioId);
      audios.add(audio);
    }
    return audios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.playlistName),
      ),
      body: FutureBuilder<List<Audio>>(
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
              return ListTile(
                title: Text(audio.title ?? 'Unknown Title'),
                subtitle: Text(audio.description ?? ''),
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
                        // Handle error
                        print('Error removing audio: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to remove audio')),
                        );
                      }
                    }
                  },
                ),
                onTap: () {
                  // Play audio or navigate to audio detail page
                },
              );
            },
          );
        },
      ),
    );
  }
}
