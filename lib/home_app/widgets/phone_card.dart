import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../phone_app/viewmodels/phone_viewmodel.dart';

class PhoneCard extends StatefulWidget {
  final void Function(String number, String name)? onOpenPhone;
  final VoidCallback? onGoPhone;
  
  final PhoneViewModel? viewModel; 

  const PhoneCard({
    super.key, 
    this.onGoPhone, 
    this.onOpenPhone,
    this.viewModel
  });

  @override
  State<PhoneCard> createState() => _PhoneCardState();
}

class _PhoneCardState extends State<PhoneCard> {
  int _tabIndex = 0;
  bool _isLoading = true;

  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> _callLogs = [];
  final Map<String, String> _numberToName = {};

  @override
  void initState() {
    super.initState();
    _loadPhoneData(); 
  }

  Future<void> _loadPhoneData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/mock_data.json');
      final decoded = json.decode(jsonString) as Map<String, dynamic>;

      final contacts = List<Map<String, dynamic>>.from(decoded['contacts'] ?? []);
      final callLogs = List<Map<String, dynamic>>.from(decoded['call_logs'] ?? []);

      final map = <String, String>{};
      for (final c in contacts) {
        final name = (c['name'] ?? '').toString();
        final number = (c['number'] ?? '').toString();
        if (number.isNotEmpty) map[number] = name;
      }

      callLogs.sort((a, b) {
        final ta = DateTime.tryParse((a['timestamp'] ?? '').toString());
        final tb = DateTime.tryParse((b['timestamp'] ?? '').toString());
        if (ta == null && tb == null) return 0;
        if (ta == null) return 1;
        if (tb == null) return -1;
        return tb.compareTo(ta);
      });

      if (mounted) {
        setState(() {
          _contacts = contacts;
          _callLogs = callLogs;
          _numberToName
            ..clear()
            ..addAll(map);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Lỗi load mock data: $e");
    }
  }

  void _openPhonePage({required String number, required String name}) {
    final cb = widget.onOpenPhone;
    if (cb != null) {
      cb(number, name);
      return;
    }
    final go = widget.onGoPhone;
    if (go != null) {
      go();
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mở mục Phone ở sidebar để sử dụng cuộc gọi.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // Tab Switcher
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildTab("Gần đây", 0),
                  _buildTab("Danh bạ", 1),
                ],
              ),
            ),
          ),

          // Nội dung
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : (_tabIndex == 0 ? _buildRecentsList() : _buildContactsList()),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isActive = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isActive ? Colors.grey[800] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentsList() {
    if (_callLogs.isEmpty) {
      return const Center(child: Text("Chưa có lịch sử cuộc gọi", style: TextStyle(color: Colors.white70)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: _callLogs.length,
      itemBuilder: (ctx, i) {
        final item = _callLogs[i];
        final number = (item['number'] ?? '').toString();
        final type = (item['type'] ?? '').toString();
        final duration = (item['duration'] ?? 0) as int;
        final ts = DateTime.tryParse((item['timestamp'] ?? '').toString());

        final name = _numberToName[number] ?? number;
        final timeLabel = _formatRelativeTime(ts);
        final iconInfo = _iconForCallType(type);

        return ListTile(
          onTap: () => widget.onGoPhone?.call(),
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(iconInfo.icon, color: iconInfo.color, size: 16),
          ),
          title: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            "$timeLabel${duration > 0 ? " • ${_formatDuration(duration)}" : ""}",
            style: const TextStyle(color: Colors.grey, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.phone, color: Colors.green, size: 18),
        );
      },
    );
  }

  Widget _buildContactsList() {
    if (_contacts.isEmpty) {
      return const Center(child: Text("Chưa có danh bạ", style: TextStyle(color: Colors.white70)));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: _contacts.length,
      itemBuilder: (ctx, i) {
        final item = _contacts[i];
        final name = (item['name'] ?? '').toString();
        final number = (item['number'] ?? '').toString();
        final initial = name.isNotEmpty ? name.trim()[0].toUpperCase() : "?";

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openPhonePage(number: number, name: name),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey,
                  child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(number, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===== HELPERS =====
  ({IconData icon, Color color}) _iconForCallType(String type) {
    switch (type) {
      case 'missed': return (icon: Icons.call_missed, color: Colors.redAccent);
      case 'incoming': return (icon: Icons.call_received, color: Colors.blueAccent);
      case 'outgoing': return (icon: Icons.call_made, color: Colors.greenAccent);
      default: return (icon: Icons.call, color: Colors.white70);
    }
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  String _formatRelativeTime(DateTime? ts) {
    if (ts == null) return "";
    final diff = DateTime.now().difference(ts);
    if (diff.inMinutes < 1) return "Vừa xong";
    if (diff.inMinutes < 60) return "${diff.inMinutes} phút trước";
    if (diff.inHours < 24) return "${diff.inHours} giờ trước";
    return "${ts.day}/${ts.month}/${ts.year}";
  }
}