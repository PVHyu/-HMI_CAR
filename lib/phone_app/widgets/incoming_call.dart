import 'package:flutter/material.dart';
import '../../phone_app/viewmodels/phone_viewmodel.dart';

class IncomingCallPopup extends StatelessWidget {
  final PhoneViewModel viewModel;

  const IncomingCallPopup({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final contactName = viewModel.getContactName(viewModel.dialNumber);
    final initial = viewModel.getContactInitial(viewModel.dialNumber);

    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade700,
                child: contactName != null
                    ? Text(
                        initial,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Colors.white70,
                      ),
              ),

              const SizedBox(height: 12),

              // Tên hoặc số
              Text(
                contactName ?? viewModel.dialNumber,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // Số điện thoại nếu có tên
              if (contactName != null) ...[
                const SizedBox(height: 4),
                Text(
                  viewModel.dialNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],

              const SizedBox(height: 8),

              // Label "Cuộc gọi đến"
              const Text(
                'Cuộc gọi đến',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 20),

              // 2 nút: Nhận cuộc gọi và Từ chối
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Nút từ chối
                  _actionButton(
                    icon: Icons.call_end,
                    label: 'Từ chối',
                    color: Colors.red,
                    onTap: () => viewModel.rejectIncomingCall(),
                  ),

                  // Nút nhận cuộc gọi
                  _actionButton(
                    icon: Icons.call,
                    label: 'Trả lời',
                    color: Colors.green,
                    onTap: () => viewModel.answerIncomingCall(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
