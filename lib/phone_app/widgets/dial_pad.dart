import 'package:flutter/material.dart';
import '../../phone_app/viewmodels/phone_viewmodel.dart';

class DialPad extends StatelessWidget {
  final PhoneViewModel viewModel;

  const DialPad({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // SỐ ĐANG NHẬP
          Text(
            viewModel.dialNumber,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // BÀN PHÍM
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 9,
              crossAxisSpacing: 9,
              childAspectRatio: 1.9,
              children: const [
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '*',
                '0',
                '#',
              ].map((value) => _dialKey(value)).toList(),
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            height: 90,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _callButton(),
                Positioned(
                  right: 32,
                  child: _deleteButton(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _dialKey(String value) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => viewModel.addDigit(value),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade700.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _callButton() {
    return GestureDetector(
      onTap: () => viewModel.startCall(),
      child: Container(
        width: 88,
        height: 88,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.call, size: 42, color: Colors.white),
      ),
    );
  }

  Widget _deleteButton() {
    return GestureDetector(
      onTap: () => viewModel.deleteLastDigit(),
      onLongPress: () => viewModel.clearDialNumber(),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey.shade700.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.backspace, size: 34, color: Colors.white),
      ),
    );
  }
}
