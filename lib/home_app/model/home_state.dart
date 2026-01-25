class HomeState {
  final String timeText;
  final String dateText;
  final bool isLoggedIn;
  final String userName;
  final String userAvatar;
  final bool isBluetoothOn;
  final double brightness;
  final double acTemp;

  const HomeState({
    required this.timeText,
    required this.dateText,
    required this.isLoggedIn,
    required this.userName,
    required this.userAvatar,
    required this.isBluetoothOn,
    required this.brightness,
    required this.acTemp,
  });

  HomeState copyWith({
    String? timeText,
    String? dateText,
    bool? isLoggedIn,
    String? userName,
    String? userAvatar,
    bool? isBluetoothOn,
    double? brightness,
    double? acTemp,
  }) {
    return HomeState(
      timeText: timeText ?? this.timeText,
      dateText: dateText ?? this.dateText,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      isBluetoothOn: isBluetoothOn ?? this.isBluetoothOn,
      brightness: brightness ?? this.brightness,
      acTemp: acTemp ?? this.acTemp,
    );
  }

  static HomeState initial() => const HomeState(
        timeText: "00:00",
        dateText: "",
        isLoggedIn: false,
        userName: "",
        userAvatar: "",
        isBluetoothOn: true,
        brightness: 1.0,
        acTemp: 0.5,
      );
}
