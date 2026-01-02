import 'package:flutter/material.dart';

class RotatingVinyl extends StatefulWidget {
  final Color albumColor; // Màu chủ đạo của album (dùng thay ảnh khi offline)
  final bool isPlaying; // Trạng thái phát nhạc
  final double size; // Kích thước đĩa

  const RotatingVinyl({
    super.key,
    required this.albumColor,
    required this.isPlaying,
    required this.size,
  });

  @override
  State<RotatingVinyl> createState() => _RotatingVinylState();
}

// Sử dụng TickerProviderStateMixin để quản lý animation
class _RotatingVinylState extends State<RotatingVinyl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller: quay 1 vòng hết 10 giây (tốc độ vừa phải)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    // Nếu vào màn hình mà đang play thì quay luôn
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  // Lắng nghe sự thay đổi của biến isPlaying từ widget cha truyền vào
  @override
  void didUpdateWidget(covariant RotatingVinyl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat(); // Bắt đầu quay lặp lại vô tận
      } else {
        _controller.stop(); // Dừng lại tại chỗ
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // RotationTransition giúp xoay widget con dựa trên controller
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black, // Viền ngoài màu đen của đĩa than
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(0, 15),
            )
          ],
        ),
        child: Padding(
          padding:
              EdgeInsets.all(widget.size * 0.05), // Độ dày viền đen đĩa than
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lớp màu album (Thay cho ảnh bìa)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.albumColor,
                  // Tạo hiệu ứng vân đĩa (tùy chọn)
                  gradient: RadialGradient(
                    colors: [
                      widget.albumColor,
                      widget.albumColor.withOpacity(0.8)
                    ],
                    stops: const [0.9, 1.0],
                  ),
                ),
              ),

              // Lỗ tròn đen ở giữa
              Container(
                width: widget.size * 0.25, // Kích thước lỗ giữa bằng 1/4 đĩa
                height: widget.size * 0.25,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade800, width: 2),
                ),
                // Nốt nhạc trắng ở chính giữa
                child: Center(
                  child: Icon(
                    Icons.music_note_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: widget.size * 0.12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
