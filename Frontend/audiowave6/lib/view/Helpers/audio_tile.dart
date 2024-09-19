import 'package:flutter/material.dart';
import '../../domain/entities/audio.dart';

class AudioTile extends StatelessWidget {
  final Audio audio;
  final VoidCallback onTap;

  const AudioTile({
    Key? key,
    required this.audio,
    required this.onTap,
  }) : super(key: key);

  // Helper method to format duration in seconds into a mm:ss format
  String _formatDuration(int durationInSeconds) {
    final minutes = durationInSeconds ~/ 60;
    final seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the provided function when the tile is tapped
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with duration overlaid
            Stack(
              children: [
                _buildThumbnail(),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: _buildDurationOverlay(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Title of the audio under the thumbnail
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                audio.title ?? 'Unknown Title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for displaying thumbnail or a placeholder
  Widget _buildThumbnail() {
    return Container(
      height: 180, // Large height for the thumbnail
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200], // Background color in case thumbnail is null
        image: audio.thumbnail != null
            ? DecorationImage(
                image: MemoryImage(audio.thumbnail!),
                fit: BoxFit.cover,
              )
            : null, // No image if thumbnail is null
      ),
      child: audio.thumbnail == null
          ? const Icon(
              Icons.headphones,
              size: 100,
              color: Colors.grey,
            )
          : null,
    );
  }

  // Widget to display the duration over the bottom right of the thumbnail
  Widget _buildDurationOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _formatDuration(audio.durationSec),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
