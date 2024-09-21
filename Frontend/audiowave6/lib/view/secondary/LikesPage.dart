// view/LikesPage.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/repositories/like_repository_impl.dart';
import '../../data/repositories/metadata_repository_impl.dart';
import '../../domain/entities/audio.dart';
import '../../domain/entities/like.dart';
import '../../services/audio_player_service.dart';
import '../Helpers/audio_list_item.dart';
import 'AudioPlayerPage.dart';

class LikesPage extends StatefulWidget {
  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final likeRepository = LikeRepositoryImpl(http.Client());
  final metadataRepository = MetadataRepositoryImpl(http.Client());

  late Future<List<Audio>> _likedAudiosFuture;

  @override
  void initState() {
    super.initState();
    _likedAudiosFuture = _fetchLikedAudios();
  }

  Future<List<Audio>> _fetchLikedAudios() async {
    List<Audio> audios = [];
    try {
      List<Like> likes = await likeRepository.getAllLikes();
      for (Like like in likes) {
        Audio audio = await metadataRepository.getAudio(like.audioId);
        audios.add(audio);
      }
    } catch (e) {
      print('Error fetching liked audios: $e');
    }
    return audios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Audios'),
      ),
      body: FutureBuilder<List<Audio>>(
        future: _likedAudiosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load liked audios'));
          }

          final audios = snapshot.data ?? [];

          if (audios.isEmpty) {
            return Center(child: Text('You have not liked any audios'));
          }

          return ListView.builder(
            itemCount: audios.length,
            itemBuilder: (context, index) {
              final audio = audios[index];
              return AudioListItem(
                audio: audio,
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
    );
  }
}
