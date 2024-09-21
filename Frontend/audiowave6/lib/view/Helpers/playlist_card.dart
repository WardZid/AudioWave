// view/playlist_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/playlist.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PlaylistCard({
    Key? key,
    required this.playlist,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can customize the design of the card as needed
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Playlist Icon or Thumbnail
              Icon(
                Icons.playlist_play_rounded,
                size: 50,
                color: Colors.deepPurple,
              ),
              SizedBox(width: 16.0),
              // Playlist Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Playlist Name
                    Text(
                      playlist.playlistName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    // Creation Date
                    Text(
                      'Created on ${DateFormat.yMMMd().format(playlist.creationDate)}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    // // Access Level
                    // Text(
                    //   'Access: ${ playlist.accessLevel.key}',
                    //   style: TextStyle(
                    //     fontSize: 14.0,
                    //     color: Colors.grey[600],
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Delete Button
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
