
import 'package:flutter/material.dart';


class NavigationControls extends StatelessWidget {
  final VoidCallback onRecenter;
  final VoidCallback onStartNavigation;
  final bool hasRoute;

  const NavigationControls({
    Key? key,
    required this.onRecenter,
    required this.onStartNavigation,
    this.hasRoute = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.my_location,
          label: 'Vị trí',
          color: Colors.blue,
          onTap: onRecenter,
        ),
        _buildControlButton(
          icon: Icons.directions,
          label: 'Chỉ đường',
          color: hasRoute ? Colors.green : Colors.grey,
          onTap: hasRoute ? onStartNavigation : null,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onClear;
  final VoidCallback onShowSuggestions;
  final VoidCallback onTap; 
  final String hintText;
  final bool hasText;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    required this.onShowSuggestions,
    required this.onTap,
    this.hintText = 'Tìm kiếm địa điểm...',
    this.hasText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AbsorbPointer(
                child: TextField(
                  controller: controller,
                  readOnly: true, // 🔴 QUAN TRỌNG
                  showCursor: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            if (hasText)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: onClear,
              ),
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.grey),
              onPressed: onShowSuggestions,
            ),
          ],
        ),
      ),
    );
  }
}

class RouteInfoCard extends StatelessWidget {
  final String destination;
  final String distance;
  final String duration;
  final VoidCallback? onStartNavigation;

  const RouteInfoCard({
    Key? key,
    required this.destination,
    required this.distance,
    required this.duration,
    this.onStartNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF4285F4).withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.navigation, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  destination.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildInfoChip(Icons.straighten, distance),
              const SizedBox(width: 10),
              _buildInfoChip(Icons.access_time, duration),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}