// import 'package:flutter/material.dart';
// import '../../../viewmodels/phone_viewmodel.dart';

// class InCallUI extends StatelessWidget {
//   final PhoneViewModel viewModel;

//   const InCallUI({super.key, required this.viewModel});

//   @override
//   Widget build(BuildContext context) {
//     if (!viewModel.showSidePad) {
//       return Center(
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: _callMainPanel(),
//         ),
//       );
//     }

//     return Row(
//       children: [
//         Expanded(
//           flex: 5,
//           child: _callMainPanel(),
//         ),
//         Expanded(
//           flex: 5,
//           child: _inCallDialPad(),
//         ),
//       ],
//     );
//   }

//   Widget _callMainPanel() {
//     final contactName = viewModel.getContactName(viewModel.dialNumber);
//     final initial = viewModel.getContactInitial(viewModel.dialNumber);

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Avatar/Icon
//         CircleAvatar(
//           radius: 50,
//           backgroundColor: Colors.grey.shade700,
//           child: Text(
//             initial,
//             style: const TextStyle(
//               fontSize: 36,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),

//         // Tên hoặc số điện thoại
//         Text(
//           contactName ?? viewModel.dialNumber,
//           style: const TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//           ),
//         ),

//         // Hiển thị số nếu có tên
//         if (contactName != null) ...[
//           const SizedBox(height: 4),
//           Text(
//             viewModel.dialNumber,
//             style: const TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ],

//         const SizedBox(height: 6),
//         const Text(
//           'Đang gọi...',
//           style: TextStyle(color: Colors.grey),
//         ),
//         const SizedBox(height: 40),

//         // Hàng 1: Contacts - Giữ cuộc gọi - Dấu +
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _callAction(
//               icon: Icons.contacts,
//               label: 'Danh bạ',
//               active: false,
//               onTap: () {},
//             ),
//             const SizedBox(width: 36),
//             _callAction(
//               icon: Icons.pause,
//               label: 'Giữ cuộc gọi',
//               active: viewModel.isHold,
//               onTap: () => viewModel.toggleHold(),
//             ),
//             const SizedBox(width: 36),
//             _callAction(
//               icon: Icons.add,
//               label: 'Thêm',
//               active: false,
//               onTap: () => viewModel.toggleSidePad(),
//             ),
//           ],
//         ),

//         const SizedBox(height: 24),

//         // Hàng 2: Loa - Mic - Bàn phím
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _callAction(
//               icon: viewModel.speakerOn ? Icons.volume_up : Icons.volume_down,
//               label: viewModel.speakerOn ? 'Loa ngoài' : 'Loa trong',
//               active: viewModel.speakerOn,
//               onTap: () => viewModel.toggleSpeaker(),
//             ),
//             const SizedBox(width: 36),
//             _callAction(
//               icon: viewModel.micOn ? Icons.mic : Icons.mic_off,
//               label: viewModel.micOn ? 'Mic bật' : 'Mic tắt',
//               active: !viewModel.micOn,
//               onTap: () => viewModel.toggleMic(),
//             ),
//             const SizedBox(width: 36),
//             _callAction(
//               icon: Icons.dialpad,
//               label: 'Bàn phím',
//               active: viewModel.showSidePad,
//               onTap: () => viewModel.toggleSidePad(),
//             ),
//           ],
//         ),

//         const SizedBox(height: 40),
//         GestureDetector(
//           onTap: () => viewModel.endCall(),
//           child: Container(
//             width: 90,
//             height: 90,
//             decoration: const BoxDecoration(
//               color: Colors.red,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.call_end, size: 40, color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _inCallDialPad() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 22),
//       child: Column(
//         children: [
//           const SizedBox(height: 70),
//           Expanded(
//             child: GridView.count(
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 3,
//               mainAxisSpacing: 12,
//               crossAxisSpacing: 12,
//               childAspectRatio: 1.9,
//               children: const [
//                 '1',
//                 '2',
//                 '3',
//                 '4',
//                 '5',
//                 '6',
//                 '7',
//                 '8',
//                 '9',
//                 '*',
//                 '0',
//                 '#',
//               ].map((value) => _dialKey(value)).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _dialKey(String value) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(999),
//       onTap: () => viewModel.addDigit(value),
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade700.withOpacity(0.9),
//           shape: BoxShape.circle,
//         ),
//         child: Text(
//           value,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _callAction({
//     required IconData icon,
//     required String label,
//     required bool active,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: active ? Colors.blueAccent : Colors.grey.shade800,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: Colors.white, size: 30),
//           ),
//           const SizedBox(height: 6),
//           Text(label, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../viewmodels/phone_viewmodel.dart';

class InCallUI extends StatelessWidget {
  final PhoneViewModel viewModel;

  const InCallUI({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (!viewModel.showSidePad && !viewModel.showContacts) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: _callMainPanel(),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _callMainPanel(),
        ),
        Expanded(
          flex: 5,
          child:
              viewModel.showSidePad ? _inCallDialPad() : _inCallContactList(),
        ),
      ],
    );
  }

  Widget _callMainPanel() {
    final contactName = viewModel.getContactName(viewModel.dialNumber);
    final initial = viewModel.getContactInitial(viewModel.dialNumber);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar/Icon
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade700,
          child: contactName != null
              ? Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.white70,
                ),
        ),
        const SizedBox(height: 16),

        // Tên hoặc số điện thoại
        Text(
          contactName ?? viewModel.dialNumber,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Hiển thị số nếu có tên
        if (contactName != null) ...[
          const SizedBox(height: 4),
          Text(
            viewModel.dialNumber,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],

        const SizedBox(height: 6),
        const Text(
          'Đang gọi...',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 40),

        // Hàng 1: Contacts - Giữ cuộc gọi - Dấu +
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _callAction(
              icon: Icons.contacts,
              label: 'Danh bạ',
              active: viewModel.showContacts,
              onTap: () => viewModel.toggleContacts(),
            ),
            const SizedBox(width: 36),
            _callAction(
              icon: Icons.pause,
              label: 'Giữ cuộc gọi',
              active: viewModel.isHold,
              onTap: () => viewModel.toggleHold(),
            ),
            const SizedBox(width: 36),
            _callAction(
              icon: Icons.add,
              label: 'Thêm',
              active: false,
              onTap: () {
                if (!viewModel.showSidePad && !viewModel.showContacts) {
                  viewModel.toggleSidePad();
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Hàng 2: Loa - Mic - Bàn phím
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _callAction(
              icon: viewModel.speakerOn ? Icons.volume_up : Icons.volume_down,
              label: viewModel.speakerOn ? 'Loa ngoài' : 'Loa trong',
              active: viewModel.speakerOn,
              onTap: () => viewModel.toggleSpeaker(),
            ),
            const SizedBox(width: 36),
            _callAction(
              icon: viewModel.micOn ? Icons.mic : Icons.mic_off,
              label: viewModel.micOn ? 'Mic bật' : 'Mic tắt',
              active: !viewModel.micOn,
              onTap: () => viewModel.toggleMic(),
            ),
            const SizedBox(width: 36),
            _callAction(
              icon: Icons.dialpad,
              label: 'Bàn phím',
              active: viewModel.showSidePad,
              onTap: () => viewModel.toggleSidePad(),
            ),
          ],
        ),

        const SizedBox(height: 40),
        GestureDetector(
          onTap: () => viewModel.endCall(),
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call_end, size: 40, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _inCallDialPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const SizedBox(height: 70),
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
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
        ],
      ),
    );
  }

  Widget _inCallContactList() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.white24, width: 1),
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Danh bạ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: viewModel.contacts.length,
              itemBuilder: (_, i) {
                final contact = viewModel.contacts[i];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade700.withOpacity(0.9),
                    child: Text(
                      contact.name[0],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    contact.number,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {
                    // Có thể thêm chức năng gọi thêm hoặc thêm vào cuộc gọi
                  },
                );
              },
            ),
          ),
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

  Widget _callAction({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: active ? Colors.blueAccent : Colors.grey.shade800,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
