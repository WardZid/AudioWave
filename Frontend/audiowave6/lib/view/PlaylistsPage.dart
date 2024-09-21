// view/PlaylistsPage.dart

import 'package:flutter/material.dart';
import '../services/playlist_service.dart';
import '../domain/entities/playlist.dart';
import '../data/repositories/playlist_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'Helpers/create_playlist_dialog.dart';
import 'Helpers/playlist_card.dart';
import 'secondary/PlaylistDetailPage.dart';

class PlaylistsPage extends StatefulWidget {
  @override
  _PlaylistsPageState createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final playlistService =
      PlaylistService(PlaylistRepositoryImpl(http.Client()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Playlists'),
      ),
      body: FutureBuilder<List<Playlist>>(
        future: playlistService.getUserPlaylists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load playlists'));
          }

          final playlists = snapshot.data ?? [];

          if (playlists.isEmpty) {
            return Center(child: Text('No playlists found'));
          }

          return ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return PlaylistCard(
                playlist: playlist,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => FractionallySizedBox(
                      heightFactor: 0.9, 
                      child: PlaylistDetailPage(
                        playlist: playlist,
                      ),
                    ),
                  );
                },
                onDelete: () async {
                  // Confirm Deletion
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Playlist'),
                      content: Text(
                          'Are you sure you want to delete this playlist?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    try {
                      await playlistService.deletePlaylist(playlist.id);
                      setState(() {}); // Refresh the list
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Playlist deleted')),
                      );
                    } catch (e) {
                      // Handle error
                      print('Error deleting playlist: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete playlist')),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => CreatePlaylistDialog(
              playlistService: playlistService,
            ),
          );
          if (result == true) {
            setState(() {}); // Refresh the list
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
