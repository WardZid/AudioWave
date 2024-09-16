import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/repositories/metadata_repository.dart';
import '../api/endpoints.dart';

class MetadataRepositoryImpl implements MetadataRepository {
  final http.Client client;

  MetadataRepositoryImpl(this.client);

  // @override
  // Future<void> fetchAudioMetadata() async {
  //   final response = await client.get(Uri.parse(Endpoints.audioMetadataUrl));
  //   if (response.statusCode == 200) {
  //     final metadata = jsonDecode(response.body);
  //     // Handle metadata
  //   } else {
  //     // Handle error
  //   }
  // }
}
