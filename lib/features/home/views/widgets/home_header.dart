import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String timeText;
  final String dateText;

  final bool isLoggedIn;
  final String userName;
  final String userAvatar;

  final bool isBluetoothOn;

  final VoidCallback onTapAvatar;
  final VoidCallback onToggleBluetooth;

  const HomeHeader({
    super.key,
    required this.timeText,
    required this.dateText,
    required this.isLoggedIn,
    required this.userName,
    required this.userAvatar,
    required this.isBluetoothOn,
    required this.onTapAvatar,
    required this.onToggleBluetooth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Chiều cao cố định cho Header
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.center, // Quan trọng: Căn giữa mọi thứ trong Stack
        children: [
          
          // --- LỚP 1: CÁC PHẦN TỬ 2 BÊN (Trái & Phải) ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy ra 2 mép
            children: [
              
              // [TRÁI] Avatar + Thanh tìm kiếm
              Row(
                children: [
                  // Avatar (Giả lập Google)
                  GestureDetector(
                    onTap: onTapAvatar,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLoggedIn ? Colors.transparent : Colors.white,
                        border: Border.all(
                          color: isLoggedIn ? Colors.transparent : Colors.white,
                          width: 2,
                        ),
                        image: (isLoggedIn && userAvatar.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(userAvatar),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: (!isLoggedIn)
                          ? Center(
                              child: Text(
                                "G",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: 15),

                  // Thanh tìm kiếm
                  Container(
                    width: 320, 
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        const Icon(Icons.search, color: Colors.white54, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isLoggedIn
                                ? "Xin chào, $userName!"
                                : "",
                            style: const TextStyle(color: Colors.white54, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // [PHẢI] Icons + Ngày tháng
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bluetooth
                  IconButton(
                    icon: Icon(
                      Icons.bluetooth,
                      color: isBluetoothOn ? Colors.blueAccent : Colors.white54,
                      size: 24,
                    ),
                    onPressed: onToggleBluetooth,
                  ),
                  
                  // Wifi
                  const Icon(Icons.wifi, color: Colors.white, size: 24),
                  
                  const SizedBox(width: 20),

                  // Ngày tháng (Được tách riêng ra đây)
                  Text(
                    dateText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ],
          ),

          // --- LỚP 2: ĐỒNG HỒ Ở CHÍNH GIỮA (Nằm đè lên trên layer 1) ---
          // Vì Stack alignment là center nên Text này sẽ luôn ở giữa màn hình
          Text(
            timeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40, // Font to
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5, // Giãn chữ ra xíu cho đẹp
            ),
          ),
        ],
      ),
    );
  }
}