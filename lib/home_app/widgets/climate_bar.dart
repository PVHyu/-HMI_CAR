import 'package:flutter/material.dart';

class ClimateBar extends StatelessWidget {
  final String temperature;
  final String humidity;
  final String windSpeed;
  final String rainChance;

  final double brightness;
  final double acTemp;
  final Function(double) onBrightnessChanged;
  final Function(double) onAcTempChanged;

  const ClimateBar({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainChance,
    required this.brightness,
    required this.acTemp,
    required this.onBrightnessChanged,
    required this.onAcTempChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white12),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: Offset(0, -5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.wb_sunny_outlined, color: Colors.white70),
          Expanded(
            child: Slider(
              value: brightness,
              min: 0.0,
              max: 1.0,
              onChanged: onBrightnessChanged,
              activeColor: Colors.white,
              inactiveColor: Colors.grey[800],
            ),
          ),

          const VerticalDivider(
              color: Colors.white12, indent: 10, endIndent: 10),
          const SizedBox(width: 10),

          _buildWeatherInfo(Icons.cloud, "$temperature°C"),
          const SizedBox(width: 20),
          _buildWeatherInfo(Icons.air, "$windSpeed km/h"),
          const SizedBox(width: 20),
          _buildWeatherInfo(Icons.water_drop, "$humidity%"),
          const SizedBox(width: 20),
          _buildWeatherInfo(Icons.umbrella, "$rainChance%"),

          const SizedBox(width: 10),
          const VerticalDivider(
              color: Colors.white12, indent: 10, endIndent: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hiển thị số độ C khi kéo
                Text("AC: ${(16 + acTemp * 14).toInt()}°C",
                    style: const TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                  child: Slider(
                    value: acTemp,
                    onChanged: onAcTempChanged,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.ac_unit, color: Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(height: 5),
        Text(text,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))
      ],
    );
  }
}
