// view/HistoryPage.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/repositories/metadata_repository_impl.dart';
import '../../domain/entities/audio.dart';
import '../../domain/entities/listen.dart';
import '../../services/audio_player_service.dart';
import '../../utils/storage_utils.dart';
import '../Helpers/audio_list_item.dart';
import 'AudioPlayerPage.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final metadataRepository = MetadataRepositoryImpl(http.Client());

  late Future<List<Audio>> _historyAudiosFuture;

  @override
  void initState() {
    super.initState();
    _historyAudiosFuture = _fetchHistoryAudios();
  }

  Future<List<Audio>> _fetchHistoryAudios() async {
    List<Audio> audios = [];
    try {
      String? userId = await StorageUtils.getUserId();
      if (userId == null) {
        throw Exception("Histories not found");
      }
      List<Listen> listens = await metadataRepository.getUserListenHistory(int.parse(userId));
      // To avoid duplicates, you can use a Set
      Set<int> audioIds = listens.map((listen) => listen.audioId!).toSet();
      for (int audioId in audioIds) {
        Audio audio = await metadataRepository.getAudio(audioId);
        audios.add(audio);
      }
    } catch (e) {
      print('Error fetching history audios: $e');
    }
    return audios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening History'),
      ),
      body: FutureBuilder<List<Audio>>(
        future: _historyAudiosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load history'));
          }

          final audios = snapshot.data ?? [];

          if (audios.isEmpty) {
            return Center(child: Text('No listening history found'));
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
