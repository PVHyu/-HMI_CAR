import 'package:flutter/material.dart';
import '../../viewmodels/phone_viewmodel.dart';
import '../../models/enums.dart';

class BottomBar extends StatelessWidget {
  final PhoneViewModel viewModel;

  const BottomBar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      color: Colors.black.withOpacity(0.6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomButton(Icons.call, true, () {}),
          _bottomButton(
            Icons.contacts,
            viewModel.rightView == PhoneRightView.contacts,
            () => viewModel.setRightView(PhoneRightView.contacts),
          ),
          _bottomButton(
            Icons.history,
            viewModel.rightView == PhoneRightView.history,
            () => viewModel.setRightView(PhoneRightView.history),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton(IconData icon, bool active, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 30,
      color: active ? Colors.blueAccent : Colors.white70,
      onPressed: onTap,
    );
  }
}
