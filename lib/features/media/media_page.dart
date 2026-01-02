import 'package:flutter/material.dart';
import 'widget/full_player.dart';
import 'widget/split_player.dart';
import 'package:hmi/features/media/logic/media_controller.dart';

final globalMediaController = MediaController();

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dùng ListenableBuilder thay vì BlocBuilder
    return ListenableBuilder(
      listenable: globalMediaController,
      builder: (context, child) {
        final controller = globalMediaController;

        // Switch giao diện
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isFullScreen
              ? FullPlayer(key: const ValueKey('Full'), controller: controller)
              : SplitPlayer(
                  key: const ValueKey('Split'), controller: controller),
        );
      },
    );
  }
}
