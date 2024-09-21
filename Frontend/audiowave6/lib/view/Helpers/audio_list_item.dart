// view/audio_list_item.dart

import 'package:flutter/material.dart';

import '../../domain/entities/audio.dart';
class AudioListItem extends StatelessWidget {
  final Audio audio;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AudioListItem({
    Key? key,
    required this.audio,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: audio.thumbnail != null
          ? Image.memory(
              audio.thumbnail!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          : Icon(Icons.music_note, size: 50),
      title: Text(
        audio.title ?? 'Unknown Title',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        audio.description ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
