import 'dart:ui';
import 'package:flutter/material.dart';

class VolumeHeadUpDisplay extends StatelessWidget {
  final bool isVisible; 
  final double volumeLevel;
  final Function(double)? onVolumeChanged; 

  const VolumeHeadUpDisplay({
    super.key,
    required this.isVisible,
    required this.volumeLevel,
    this.onVolumeChanged,
  });


 @override
Widget build(BuildContext context) {
  return AnimatedPositioned(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
    top: isVisible ? 20 : -100,
    left: 0,
    right: 0,
    child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material( 
            color: Colors.transparent, 
            child: Container(
              width: 300,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(
                    volumeLevel == 0 ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: SliderComponentShape.noOverlay,
                        activeTrackColor: Colors.blueAccent,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                      ),
                      child: Slider(
                        value: volumeLevel,
                        onChanged: onVolumeChanged,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    '${(volumeLevel * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ------------------------------------
        ),
      ),
    ),
  );
}
}