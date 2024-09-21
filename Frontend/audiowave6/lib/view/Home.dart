import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/repositories/metadata_repository_impl.dart';
import '../domain/entities/audio.dart';
import 'Helpers/audio_tile.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // Updated to use Key

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final metadataRepository = MetadataRepositoryImpl(http.Client());
  late Future<List<Audio>> _audiosFuture;

  @override
  void initState() {
    super.initState();
    _audiosFuture = _fetchAudios();
  }

  Future<List<Audio>> _fetchAudios() async {
    try {
      List<Audio> audios = await metadataRepository.getAllAudios();
      audios.shuffle(); // Scramble the list
      return audios;
    } catch (e) {
      print('Error fetching audios: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AudioWave'),
      ),
      body: FutureBuilder<List<Audio>>(
        future: _audiosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurred, display an error message
            return Center(child: Text('Failed to load audios'));
          } else {
            // When data is available, display the list of audios
            final audios = snapshot.data ?? [];

            if (audios.isEmpty) {
              return Center(child: Text('No audios available'));
            }

            return ListView.builder(
              itemCount: audios.length,
              itemBuilder: (context, index) {
                return AudioTile(audio: audios[index]);
              },
            );
          }
        },
      ),
    );
  }
}