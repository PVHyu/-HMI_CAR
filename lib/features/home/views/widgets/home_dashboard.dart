import 'package:flutter/material.dart';
import 'package:hmi/features/home/views/widgets/map_card.dart';
import 'package:hmi/features/home/views/widgets/media_card.dart';
import 'package:hmi/features/home/views/widgets/phone_card.dart';

class HomeDashboard extends StatelessWidget {
  final VoidCallback? onGoPhone;
  final VoidCallback? onGoMedia;
  const HomeDashboard({super.key, this.onGoPhone, this.onGoMedia});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 3, child: MapCard()),
        const SizedBox(width: 25),
        Expanded(
          flex: 2,
          child: MediaCard(
            onTap: onGoMedia ?? () {},
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          flex: 2,
          child: PhoneCard(
            onGoPhone: onGoPhone,
          ),
        ),
      ],
    );
  }
}
