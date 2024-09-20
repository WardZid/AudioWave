// now_playing_bar.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../services/audio_player_service.dart';

class NowPlayingBar extends StatelessWidget {
  final audioPlayerService = AudioPlayerService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayerService.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        if (audioPlayerService.currentAudio == null) {
          return SizedBox.shrink();
        }

        return Container(
          color: Colors.grey[200],
          child: ListTile(
            leading: Icon(Icons.music_note),
            title: Text(audioPlayerService.currentAudio?.title ?? 'Unknown Title'),
            trailing: IconButton(
              icon: Icon(
                playerState?.playing ?? false ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (playerState?.playing ?? false) {
                  audioPlayerService.pause();
                } else {
                  audioPlayerService.resume();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
