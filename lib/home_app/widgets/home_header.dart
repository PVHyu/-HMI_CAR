import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String timeText;
  final String dateText;
  final bool isBluetoothOn;
  final VoidCallback onToggleBluetooth;
  final VoidCallback onVolumeTap;

  const HomeHeader({
    super.key,
    required this.timeText,
    required this.dateText,
    required this.isBluetoothOn,
    required this.onToggleBluetooth,
    required this.onVolumeTap,
  });

  @override
  Widget build(BuildContext context) {
    const double itemSpacing = 20.0; 

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            timeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          const Spacer(),

          Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              // Nút Volume
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.white, size: 24),
                onPressed: onVolumeTap,
                padding: EdgeInsets.zero, 
                constraints: const BoxConstraints(), 
              ),
              

          

              const SizedBox(width: itemSpacing), 

              // Icon Wifi
              const Icon(Icons.wifi, color: Colors.white, size: 24),

              const SizedBox(width: itemSpacing), 

              // Ngày tháng
              Text(
                dateText,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}