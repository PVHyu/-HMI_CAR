import 'package:flutter/material.dart';
import '../../phone_app/viewmodels/phone_viewmodel.dart';
import '../../phone_app/models/enums.dart';

class CallHistory extends StatelessWidget {
  final PhoneViewModel viewModel;

  const CallHistory({super.key, required this.viewModel});

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Nếu trong ngày hôm nay
    if (difference.inDays == 0) {
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    // Nếu đã qua ngày
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final day = dateTime.day;
    final month = months[dateTime.month - 1];

    return '$day $month';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: viewModel.callLogs.length,
      itemBuilder: (_, i) {
        final log = viewModel.callLogs[i];
        final contactName = viewModel.getContactName(log.number);

        IconData icon;
        Color color;
        String label;

        switch (log.type) {
          case CallType.outgoing:
            icon = Icons.call_made;
            color = const Color.fromARGB(255, 0, 255, 55);
            label = 'Cuộc gọi đi';
            break;

          case CallType.incoming:
            icon = Icons.call_received;
            color = const Color.fromARGB(255, 0, 255, 55);
            label = 'Cuộc gọi đến';
            break;

          case CallType.missed:
            icon = Icons.call_missed;
            color = Colors.redAccent;
            label = 'Cuộc gọi nhỡ';
            break;
        }

        return ListTile(
          leading: Icon(icon, color: color, size: 30),
          title: Text(
            contactName ?? log.number,
            style: TextStyle(
              fontSize: 18,
              color: log.type == CallType.missed
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : null,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: log.type == CallType.missed
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : null,
                  fontSize: 14,
                ),
              ),
              if (contactName != null) ...[
                const Text(' • ', style: TextStyle(color: Colors.grey)),
                Text(
                  log.number,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
              if (log.duration > 0) ...[
                const Text(' • ', style: TextStyle(color: Colors.grey)),
                Text(
                  log.formattedDuration,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatDateTime(log.dateTime),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                iconSize: 26,
                onPressed: () => viewModel.callFromContact(log.number),
              ),
            ],
          ),
        );
      },
    );
  }
}
