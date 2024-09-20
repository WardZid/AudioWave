// now_playing_bar.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../services/audio_player_service.dart';
import '../secondary/AudioPlayerPage.dart';

class NowPlayingBar extends StatelessWidget {
  final audioPlayerService = AudioPlayerService();

  NowPlayingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayerService.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        // Check if there's an audio currently playing
        if (audioPlayerService.currentAudio == null) {
          return SizedBox.shrink(); // Return empty widget if no audio is playing
        }

        final isPlaying = playerState?.playing ?? false;
        final currentAudio = audioPlayerService.currentAudio!;

        return GestureDetector(
          onTap: () {
            // Navigate to the AudioPlayerPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioPlayerPage(audio: currentAudio),
              ),
            );
          },
          child: Container(
            color: Colors.grey[200],
            child: ListTile(
              leading: currentAudio.thumbnail != null
                  ? Image.memory(
                      currentAudio.thumbnail!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.music_note, size: 50),
              title: Text(
                currentAudio.title ?? 'Unknown Title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                isPlaying ? 'Playing' : 'Paused',
              ),
              trailing: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  if (isPlaying) {
                    audioPlayerService.pause();
                  } else {
                    audioPlayerService.resume();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
