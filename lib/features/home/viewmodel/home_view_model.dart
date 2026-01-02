import 'dart:async';
import 'package:flutter/foundation.dart';
import '../model/home_state.dart';

class HomeViewModel extends ChangeNotifier {
  HomeState _state = HomeState.initial();
  HomeState get state => _state;

  Timer? _timer;
  bool _disposed = false;

  HomeViewModel() {
    _tickTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickTime());
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }

  void _set(HomeState s) {
    _state = s;
    if (!_disposed) notifyListeners();
  }

  void _tickTime() {
    final now = DateTime.now();
    final timeText =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final dateText = "Ngày ${now.day}/${now.month}/${now.year}";
    _set(_state.copyWith(timeText: timeText, dateText: dateText));
  }

  void toggleBluetooth() {
    _set(_state.copyWith(isBluetoothOn: !_state.isBluetoothOn));
  }

  void setBrightness(double v) {
    _set(_state.copyWith(brightness: v));
  }

  void setAcTemp(double v) {
    _set(_state.copyWith(acTemp: v));
  }

  // auth mock: View tự mở dialog, xong gọi hàm này để set state
  void loginMock({required String userName, required String avatarUrl}) {
    _set(_state.copyWith(
      isLoggedIn: true,
      userName: userName,
      userAvatar: avatarUrl,
    ));
  }

  void logout() {
    _set(_state.copyWith(
      isLoggedIn: false,
      userName: "",
      userAvatar: "",
    ));
  }
}
