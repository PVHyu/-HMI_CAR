// enum HmiPage { home, phone }

// enum PhoneRightView { contacts, history }

// enum CallType {
//   outgoing,
//   incoming,
//   missed,
// }
enum HmiPage { home, phone }

enum PhoneRightView { contacts, history }

enum CallType {
  outgoing,
  incoming,
  missed,
}

enum CallState {
  idle, // Không gọi
  dialing, // Đang quay số (cuộc gọi đi)
  ringing, // Đang đổ chuông (cuộc gọi đến)
  connected, // Đã kết nối
  disconnected, // Đã ngắt
  unreachable // Không liên lạc được
}
