import 'package:flutter/material.dart';
import '../../domain/entities/audio.dart';

class AudioCard extends StatelessWidget {
  final Audio audio;
  final VoidCallback onTap;

  const AudioCard({
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
      onTap: onTap, // Call the provided function when the card is tapped
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // Thumbnail (Placeholder if not available)
            _buildThumbnail(),
            const SizedBox(width: 10),
            // Audio details
            Expanded(
              child: _buildAudioDetails(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for displaying thumbnail or a placeholder
  Widget _buildThumbnail() {
    return Container(
      width: 80,
      height: 80,
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
              size: 40,
              color: Colors.grey,
            )
          : null,
    );
  }

  // Widget for displaying audio title, uploaderId, and duration
  Widget _buildAudioDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of the audio
          Text(
            audio.title ?? 'Unknown Title',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          /* const SizedBox(height: 4),
          // Uploader ID
          Text(
            '${audio.uploaderId ?? 'Unknown'}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4), */
          // Duration
          Text(
            '${_formatDuration(audio.durationSec)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
