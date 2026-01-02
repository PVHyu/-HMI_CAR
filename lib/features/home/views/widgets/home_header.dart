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
    return Row(
      children: [
        GestureDetector(
          onTap: onTapAvatar,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[800],
            backgroundImage: (isLoggedIn && userAvatar.isNotEmpty)
                ? NetworkImage(userAvatar)
                : null,
            child: (!isLoggedIn)
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isLoggedIn
                        ? "Xin chào, $userName!"
                        : "Đăng nhập Google để đồng bộ",
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              timeText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
            Text(
              dateText,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(width: 15),
        IconButton(
          icon: Icon(
            Icons.bluetooth,
            color: isBluetoothOn ? Colors.blueAccent : Colors.grey,
          ),
          onPressed: onToggleBluetooth,
        ),
        const Icon(Icons.wifi, color: Colors.white),
      ],
    );
  }
}
