import 'package:flutter/material.dart';
import 'package:hmi/features/home/views/widgets/map_card.dart';
import 'package:hmi/features/home/views/widgets/media_card.dart';
import 'package:hmi/features/home/views/widgets/phone_card.dart';
// Import ViewModel (Nếu báo lỗi dòng này nghĩa là bạn chưa tạo file phone_viewmodel.dart, hãy báo mình nhé)
import '../../../phone/viewmodels/phone_viewmodel.dart'; 

class HomeDashboard extends StatelessWidget {
  final VoidCallback? onGoPhone;
  final VoidCallback? onGoMedia;
  
  // Khai báo biến nhận ViewModel
  final PhoneViewModel? phoneViewModel;

  const HomeDashboard({
    super.key, 
    this.onGoPhone, 
    this.onGoMedia, 
    this.phoneViewModel // Thêm vào constructor để nhận dữ liệu
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // MapCard (Flex 3)
        const Expanded(flex: 3, child: MapCard()),
        
        const SizedBox(width: 25),
        
        // MediaCard (Flex 2)
        Expanded(
          flex: 3,
          child: MediaCard(
            onTap: onGoMedia ?? () {},
          ),
        ),
        
        const SizedBox(width: 25),
        
        // PhoneCard (Flex 2)
        Expanded(
          flex: 3,
          child: PhoneCard(
            onGoPhone: onGoPhone,
            // Truyền ViewModel xuống PhoneCard
            // LƯU Ý: Nếu báo lỗi ở dòng 'viewModel:', nghĩa là file phone_card.dart chưa được cập nhật.
            viewModel: phoneViewModel, 
          ),
        ),
      ],
    );
  }
}