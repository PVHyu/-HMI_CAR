import 'package:flutter/material.dart';
import '../../home_app/widgets/map_card.dart';
import '../../home_app/widgets/media_card.dart';
import '../../home_app/widgets/phone_card.dart';
import '../../phone_app/viewmodels/phone_viewmodel.dart';

class HomeDashboard extends StatelessWidget {
  final VoidCallback? onGoPhone;
  final VoidCallback? onGoMedia;
  final PhoneViewModel? phoneViewModel;
  final VoidCallback? onGoMap;

  const HomeDashboard({
    super.key,
    this.onGoPhone,
    this.onGoMedia,
    this.phoneViewModel,
    this.onGoMap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: onGoMap, 
            child: const MapCard(), 
          ),
        ),
        
        const SizedBox(width: 25),
        
        Expanded(
          flex: 3,
          child: MediaCard(
            onTap: onGoMedia ?? () {},
          ),
        ),
        
        const SizedBox(width: 25),
        
        Expanded(
          flex: 3,
          child: PhoneCard(
            onGoPhone: onGoPhone,
            viewModel: phoneViewModel, 
          ),
        ),

      ],
    );
  }
}