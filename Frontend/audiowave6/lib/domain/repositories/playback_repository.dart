import 'dart:typed_data';

abstract class PlaybackRepository {
  Future<Uint8List> getChunk(int audioId, int chunkNumber);
  Future<Uint8List> getCombinedChunks(int audioId, int firstChunkNumber, int lastChunkNumber);
}
