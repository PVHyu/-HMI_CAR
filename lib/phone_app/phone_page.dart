import 'package:flutter/material.dart';
import '../phone_app/viewmodels/phone_viewmodel.dart';
import '../phone_app/models/enums.dart';
import 'widgets/dial_pad.dart';
import 'widgets/contact_list.dart';
import 'widgets/call_history.dart';
import 'widgets/in_call_ui.dart';
import 'widgets/incoming_call.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final PhoneViewModel _viewModel = PhoneViewModel();
  static const double _radius = 18;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              // Nền chung trong suốt nhẹ để thấy bầu trời sao
              color: const Color(0xFF121212).withOpacity(0.70),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: Stack(
                children: [
                  // Giao diện chính
                  _viewModel.isCalling &&
                          _viewModel.callState != CallState.ringing
                      ? InCallUI(viewModel: _viewModel)
                      : Row(
                          children: [
                            // KHUNG 1: BÀN PHÍM SỐ (DialPad) - Bên Trái
                            Expanded(
                              flex: 5,
                              child: Container(
                                // Có thể thêm border phải để ngăn cách nếu muốn
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        color: Colors.white10, width: 1),
                                  ),
                                ),
                                child: DialPad(viewModel: _viewModel),
                              ),
                            ),

                            // KHUNG 2: DANH BẠ & LỊCH SỬ + NÚT BẤM - Bên Phải
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  // Phần hiển thị danh sách (Chiếm phần lớn diện tích)
                                  Expanded(
                                    child: _viewModel.rightView ==
                                            PhoneRightView.contacts
                                        ? ContactList(viewModel: _viewModel)
                                        : CallHistory(viewModel: _viewModel),
                                  ),

                                  // Phần thanh nút bấm (Nằm gọn dưới chân khung phải)
                                  _buildRightControlBar(),
                                ],
                              ),
                            ),
                          ],
                        ),

                  // Popup cuộc gọi đến
                  if (_viewModel.callState == CallState.ringing)
                    IncomingCallPopup(viewModel: _viewModel),

                  // Nút test
                  if (_viewModel.callState == CallState.idle)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Opacity(
                        opacity: 0.5, // Làm mờ nút test cho đỡ vướng mắt
                        child: ElevatedButton(
                          onPressed: () =>
                              _viewModel.simulateIncomingCall('0901234567'),
                          child: const Text('Simulate Call',
                              style: TextStyle(fontSize: 10)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget chứa 2 nút Danh bạ/Lịch sử (Chỉ dành cho khung bên phải)
  Widget _buildRightControlBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.transparent, // Nền trong suốt
        border: Border(
          top: BorderSide(
              color: Colors.white10, width: 1), // Đường kẻ ngăn cách với list
        ),
      ),
      child: Row(
        children: [
          // Nút Danh bạ
          Expanded(
            child: _buildTabButton(
              icon: Icons.contacts,
              label: "Danh bạ",
              isSelected: _viewModel.rightView == PhoneRightView.contacts,
              onTap: () =>
                  _viewModel.setRightView(PhoneRightView.contacts),
            ),
          ),
          
          // Đường kẻ dọc nhỏ giữa 2 nút (tùy chọn)
          Container(width: 1, height: 20, color: Colors.white12),

          // Nút Lịch sử
          Expanded(
            child: _buildTabButton(
              icon: Icons.history,
              label: "Gần đây",
              isSelected: _viewModel.rightView == PhoneRightView.history,
              onTap: () =>
                  _viewModel.setRightView(PhoneRightView.history),
            ),
          ),
        ],
      ),
    );
  }

  // Helper để vẽ nút bấm đẹp hơn
  Widget _buildTabButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? Colors.blueAccent : Colors.white54;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}