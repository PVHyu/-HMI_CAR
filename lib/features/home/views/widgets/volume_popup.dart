import 'package:flutter/material.dart';

// Hàm helper để gọi nhanh từ bên ngoài
void showVolumeControl(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent, // Không che nội dung nền
    builder: (context) {
      return const VolumePopup();
    },
  );
}

class VolumePopup extends StatefulWidget {
  const VolumePopup({super.key});

  @override
  State<VolumePopup> createState() => _VolumePopupState();
}

class _VolumePopupState extends State<VolumePopup> {
  double _currentVol = 0.5;

  void _updateVolume(double value) {
    setState(() {
      _currentVol = value.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 100, // Vị trí ngay cạnh Sidebar
          bottom: 30, // Cách đáy 30px
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 70, 
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E).withOpacity(0.95),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.white24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45, 
                    blurRadius: 10, 
                    offset: Offset(0, 5)
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Số %
                  Text(
                    "${(_currentVol * 100).toInt()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  // 2. Nút Cộng (+)
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _updateVolume(_currentVol + 0.1),
                  ),

                  // 3. Thanh trượt dọc
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3, // Xoay -90 độ
                      child: Slider(
                        value: _currentVol,
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.blueAccent,
                        inactiveColor: Colors.grey[800],
                        onChanged: (v) => _updateVolume(v),
                      ),
                    ),
                  ),

                  // 4. Nút Trừ (-)
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.grey),
                    onPressed: () => _updateVolume(_currentVol - 0.1),
                  ),

                  // Icon trang trí
                  const Icon(Icons.volume_up, size: 20, color: Colors.white54),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}