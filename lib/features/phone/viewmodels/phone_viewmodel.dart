import 'dart:async';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/call_log.dart';
import '../models/enums.dart';
import '/services/mock_data_service.dart';

class PhoneViewModel extends ChangeNotifier {
  String _dialNumber = '';
  PhoneRightView _rightView = PhoneRightView.contacts;
  bool _isCalling = false;
  bool _speakerOn = false;
  bool _isHold = false;
  bool _showSidePad = false;
  bool _micOn = true;
  bool _showContacts = false;
  CallState _callState = CallState.idle;

  int _callDuration = 0;
  Timer? _ringTimer;
  Timer? _callTimer;
  DateTime? _callStartTime;

  List<Contact> _mockContacts = [];
  List<CallLog> _callLogs = [];
  List<String> _unreachableNumbers = [];
  int _ringTimeout = 15;

  // Getters
  String get dialNumber => _dialNumber;
  PhoneRightView get rightView => _rightView;
  bool get isCalling => _isCalling;
  bool get speakerOn => _speakerOn;
  bool get isHold => _isHold;
  bool get showSidePad => _showSidePad;
  bool get micOn => _micOn;
  bool get showContacts => _showContacts;
  CallState get callState => _callState;
  int get callDuration => _callDuration;
  List<Contact> get contacts => _mockContacts;
  List<CallLog> get callLogs => _callLogs;

  PhoneViewModel() {
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    _mockContacts = await MockDataService.loadContacts();
    _callLogs = await MockDataService.loadCallLogs();
    _ringTimeout = await MockDataService.getRingTimeout();
    _unreachableNumbers = await MockDataService.getUnreachableNumbers();
    notifyListeners();
  }

  // Methods
  void addDigit(String digit) {
    _dialNumber += digit;
    notifyListeners();
  }

  void deleteLastDigit() {
    if (_dialNumber.isNotEmpty) {
      _dialNumber = _dialNumber.substring(0, _dialNumber.length - 1);
      notifyListeners();
    }
  }

  void clearDialNumber() {
    _dialNumber = '';
    notifyListeners();
  }

  void setRightView(PhoneRightView view) {
    _rightView = view;
    notifyListeners();
  }

  void startCall() {
    if (_dialNumber.isEmpty) return;

    // Kiểm tra số không liên lạc được
    if (_unreachableNumbers.contains(_dialNumber)) {
      _isCalling = true;
      _callState = CallState.unreachable;
      _showSidePad = false;
      _showContacts = false;
      _callStartTime = DateTime.now();

      notifyListeners();

      // Hiển thị "Không liên lạc được" trong 2 giây rồi kết thúc
      Future.delayed(const Duration(seconds: 2), () {
        if (_callState == CallState.unreachable) {
          _handleUnreachableCall();
        }
      });
      return;
    }

    // Cuộc gọi bình thường
    _isCalling = true;
    _showSidePad = false;
    _showContacts = false;
    _callState = CallState.dialing;
    _callStartTime = DateTime.now();

    // Đếm thời gian cho timeout (15 giây)
    int elapsedSeconds = 0;
    _ringTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds++;

      if (elapsedSeconds >= _ringTimeout) {
        // Hết 15 giây không bắt máy
        _ringTimer?.cancel();
        _handleMissedCall();
      }
    });

    // Simulate: Người nhận bắt máy sau 2-8 giây (random)
    final randomDelay = 2 + (DateTime.now().millisecond % 7);
    Future.delayed(Duration(seconds: randomDelay), () {
      if (_callState == CallState.dialing) {
        _answerCall();
      }
    });

    notifyListeners();
  }

  void _answerCall() {
    _ringTimer?.cancel();
    _callState = CallState.connected;
    _callDuration = 0;

    // Bắt đầu đếm thời gian cuộc gọi
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDuration++;
      notifyListeners();
    });

    notifyListeners();
  }

  void _handleMissedCall() {
    _callState = CallState.disconnected;

    // Thêm vào lịch sử cuộc gọi nhỡ
    final missedCall = CallLog(
      _dialNumber,
      CallType.missed,
      DateTime.now(),
      duration: 0,
    );
    _callLogs.insert(0, missedCall);

    // Đợi 2 giây rồi reset
    Future.delayed(const Duration(seconds: 2), () {
      endCall();
    });

    notifyListeners();
  }

  void _handleUnreachableCall() {
    _callState = CallState.disconnected;

    // Thêm vào lịch sử cuộc gọi không liên lạc được
    final unreachableCall = CallLog(
      _dialNumber,
      CallType.missed,
      DateTime.now(),
      duration: 0,
    );
    _callLogs.insert(0, unreachableCall);

    // Đợi 1 giây rồi reset
    Future.delayed(const Duration(seconds: 1), () {
      endCall();
    });

    notifyListeners();
  }

  void endCall() {
    _ringTimer?.cancel();
    _callTimer?.cancel();

    // Nếu cuộc gọi đã kết nối, lưu vào lịch sử
    if (_callState == CallState.connected && _callDuration > 0) {
      final completedCall = CallLog(
        _dialNumber,
        CallType.outgoing,
        _callStartTime ?? DateTime.now(),
        duration: _callDuration,
      );
      _callLogs.insert(0, completedCall);
    }

    _isCalling = false;
    _showSidePad = false;
    _dialNumber = '';
    _speakerOn = false;
    _isHold = false;
    _micOn = true;
    _showContacts = false;
    _callState = CallState.idle;
    _callDuration = 0;
    _callStartTime = null;

    notifyListeners();
  }

  void toggleSpeaker() {
    _speakerOn = !_speakerOn;
    notifyListeners();
  }

  void toggleHold() {
    _isHold = !_isHold;
    if (_isHold) {
      _callTimer?.cancel();
    } else {
      _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _callDuration++;
      });
    }
    notifyListeners();
  }

  void toggleSidePad() {
    _showSidePad = !_showSidePad;
    if (_showSidePad) {
      _showContacts = false;
    }
    notifyListeners();
  }

  void toggleMic() {
    _micOn = !_micOn;
    notifyListeners();
  }

  void toggleContacts() {
    _showContacts = !_showContacts;
    if (_showContacts) {
      _showSidePad = false;
    }
    notifyListeners();
  }

  void callFromContact(String number) {
    _dialNumber = number;
    notifyListeners();
  }

  // Simulate cuộc gọi đến
  void simulateIncomingCall(String number) {
    _dialNumber = number;
    _isCalling = true;
    _callState = CallState.ringing;
    _callStartTime = DateTime.now();

    // Đếm thời gian cho timeout (15 giây)
    int elapsedSeconds = 0;
    _ringTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds++;

      if (elapsedSeconds >= _ringTimeout) {
        // Không bắt máy -> cuộc gọi nhỡ
        _ringTimer?.cancel();
        _handleIncomingMissedCall();
      }
    });

    notifyListeners();
  }

  void answerIncomingCall() {
    _ringTimer?.cancel();
    _callState = CallState.connected;
    _callDuration = 0;
    _callStartTime = DateTime.now();

    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDuration++;
      notifyListeners();
    });

    notifyListeners();
  }

  void rejectIncomingCall() {
    _ringTimer?.cancel();
    _callState = CallState.disconnected;

    // Thêm vào lịch sử cuộc gọi nhỡ
    final missedCall = CallLog(
      _dialNumber,
      CallType.missed,
      DateTime.now(),
      duration: 0,
    );
    _callLogs.insert(0, missedCall);

    // Reset về trạng thái ban đầu
    Future.delayed(const Duration(milliseconds: 500), () {
      endCall();
    });

    notifyListeners();
  }

  void _handleIncomingMissedCall() {
    _callState = CallState.disconnected;

    final missedCall = CallLog(
      _dialNumber,
      CallType.missed,
      DateTime.now(),
      duration: 0,
    );
    _callLogs.insert(0, missedCall);

    Future.delayed(const Duration(seconds: 1), () {
      endCall();
    });

    notifyListeners();
  }

  // Helper methods
  String? getContactName(String number) {
    try {
      final contact = _mockContacts.firstWhere((c) => c.number == number);
      return contact.name;
    } catch (e) {
      return null;
    }
  }

  String getContactInitial(String number) {
    final name = getContactName(number);
    if (name != null && name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '#';
  }

  String get formattedCallDuration {
    final minutes = _callDuration ~/ 60;
    final seconds = _callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ringTimer?.cancel();
    _callTimer?.cancel();
    super.dispose();
  }
}
