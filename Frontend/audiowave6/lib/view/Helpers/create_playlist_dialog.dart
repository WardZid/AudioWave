// widgets/create_playlist_dialog.dart

import 'package:flutter/material.dart';
import '../../domain/entities/access_level.dart';
import '../../services/playlist_service.dart';

class CreatePlaylistDialog extends StatefulWidget {
  final PlaylistService playlistService;

  const CreatePlaylistDialog({Key? key, required this.playlistService})
      : super(key: key);

  @override
  _CreatePlaylistDialogState createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final _formKey = GlobalKey<FormState>();
  String _playlistName = '';

  List<AccessLevel> _accessLevels = [];
  AccessLevel? _selectedAccessLevel;

  @override
  void initState() {
    super.initState();
    _fetchAccessLevels();
  }

  Future<void> _fetchAccessLevels() async {
    try {
      List<AccessLevel> accessLevels =
          await widget.playlistService.getAccessLevels();
      setState(() {
        _accessLevels = accessLevels;
        _selectedAccessLevel = accessLevels.isNotEmpty ? accessLevels[0] : null;
      });
    } catch (e) {
      // Handle error
      print('Error fetching access levels: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Playlist'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Playlist Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a playlist name';
                }
                return null;
              },
              onSaved: (value) {
                _playlistName = value!;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<AccessLevel>(
              value: _selectedAccessLevel,
              decoration: InputDecoration(labelText: 'Visibility'),
              items: _accessLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.key),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAccessLevel = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              try {
                await widget.playlistService.createPlaylist(
                    _playlistName, _selectedAccessLevel ?? _accessLevels[0]);
                Navigator.pop(context, true); // Indicate success
              } catch (e) {
                // Handle error (e.g., show a snackbar)
                print('Error creating playlist: $e');
              }
            }
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}
