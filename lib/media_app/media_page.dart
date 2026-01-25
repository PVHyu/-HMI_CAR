import 'package:flutter/material.dart';
import '../media_app/viewmodels/media_viewmodel.dart';
import 'widget/full_player.dart';
import 'widget/split_player.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Gọi Singleton: Nó sẽ lấy đúng dữ liệu nhạc đang phát ở ngoài Home
    final MediaViewModel viewModel = MediaViewModel();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        
        // Switch giao diện dựa trên biến trong ViewModel
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: viewModel.isFullScreen
              // 3. Truyền viewModel vào để các con cũng đồng bộ
              ? FullPlayer(key: const ValueKey('Full'), viewModel: viewModel)
              : SplitPlayer(key: const ValueKey('Split'), viewModel: viewModel),
        );
      },
    );
  }
}