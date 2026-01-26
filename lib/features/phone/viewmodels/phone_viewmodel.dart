// // import 'package:flutter/material.dart';
// // import '../models/contact.dart';
// // import '../models/call_log.dart';
// // import '../models/enums.dart';

// // class PhoneViewModel extends ChangeNotifier {
// //   String _dialNumber = '';
// //   PhoneRightView _rightView = PhoneRightView.contacts;
// //   bool _isCalling = false;
// //   bool _speakerOn = false;
// //   bool _isHold = false;
// //   bool _showSidePad = false;

// //   // Mock data
// //   final List<Contact> _mockContacts = [
// //     const Contact(name: 'Nguyễn Văn An', number: '0901234567'),
// //     const Contact(name: 'Trần Thị Bình', number: '0912345678'),
// //     const Contact(name: 'Lê Hoàng Long', number: '0987654321'),
// //     const Contact(name: 'Phạm Minh Tuấn', number: '0934567890'),
// //     const Contact(name: 'Đặng Quốc Huy', number: '0978123456'),
// //     const Contact(name: 'Hoàng Gia Bảo', number: '0963456789'),
// //     const Contact(name: 'Võ Thanh Tùng', number: '0945678123'),
// //     const Contact(name: 'Bùi Thị Lan', number: '0926789345'),
// //   ];

// //   final List<CallLog> _callLogs = [
// //     CallLog('0123456780', CallType.outgoing),
// //     CallLog('0123456781', CallType.incoming),
// //     CallLog('0123456782', CallType.missed),
// //     CallLog('0123456783', CallType.outgoing),
// //     CallLog('0123456784', CallType.missed),
// //     CallLog('0123456785', CallType.incoming),
// //   ];

// //   // Getters
// //   String get dialNumber => _dialNumber;
// //   PhoneRightView get rightView => _rightView;
// //   bool get isCalling => _isCalling;
// //   bool get speakerOn => _speakerOn;
// //   bool get isHold => _isHold;
// //   bool get showSidePad => _showSidePad;
// //   List<Contact> get contacts => _mockContacts;
// //   List<CallLog> get callLogs => _callLogs;

// //   // Methods
// //   void addDigit(String digit) {
// //     _dialNumber += digit;
// //     notifyListeners();
// //   }

// //   void deleteLastDigit() {
// //     if (_dialNumber.isNotEmpty) {
// //       _dialNumber = _dialNumber.substring(0, _dialNumber.length - 1);
// //       notifyListeners();
// //     }
// //   }

// //   void clearDialNumber() {
// //     _dialNumber = '';
// //     notifyListeners();
// //   }

// //   void setRightView(PhoneRightView view) {
// //     _rightView = view;
// //     notifyListeners();
// //   }

// //   void startCall() {
// //     if (_dialNumber.isNotEmpty) {
// //       _isCalling = true;
// //       _showSidePad = false;
// //       notifyListeners();
// //     }
// //   }

// //   void endCall() {
// //     _isCalling = false;
// //     _showSidePad = false;
// //     _dialNumber = '';
// //     _speakerOn = false;
// //     _isHold = false;
// //     notifyListeners();
// //   }

// //   void toggleSpeaker() {
// //     _speakerOn = !_speakerOn;
// //     notifyListeners();
// //   }

// //   void toggleHold() {
// //     _isHold = !_isHold;
// //     notifyListeners();
// //   }

// //   void toggleSidePad() {
// //     _showSidePad = !_showSidePad;
// //     notifyListeners();
// //   }

// //   void callFromContact(String number) {
// //     _dialNumber = number;
// //     notifyListeners();
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../models/contact.dart';
// import '../models/call_log.dart';
// import '../models/enums.dart';

// class PhoneViewModel extends ChangeNotifier {
//   String _dialNumber = '';
//   PhoneRightView _rightView = PhoneRightView.contacts;
//   bool _isCalling = false;
//   bool _speakerOn = false;
//   bool _isHold = false;
//   bool _showSidePad = false;
//   bool _micOn = true;

//   // Mock data
//   final List<Contact> _mockContacts = [
//     const Contact(name: 'Nguyễn Văn An', number: '0901234567'),
//     const Contact(name: 'Trần Thị Bình', number: '0912345678'),
//     const Contact(name: 'Lê Hoàng Long', number: '0987654321'),
//     const Contact(name: 'Phạm Minh Tuấn', number: '0934567890'),
//     const Contact(name: 'Đặng Quốc Huy', number: '0978123456'),
//     const Contact(name: 'Hoàng Gia Bảo', number: '0963456789'),
//     const Contact(name: 'Võ Thanh Tùng', number: '0945678123'),
//     const Contact(name: 'Bùi Thị Lan', number: '0926789345'),
//   ];

//   final List<CallLog> _callLogs = [
//     CallLog('0901234567', CallType.outgoing,
//         DateTime.now().subtract(const Duration(minutes: 15))),
//     CallLog('0912345678', CallType.incoming,
//         DateTime.now().subtract(const Duration(hours: 2))),
//     CallLog('0987654321', CallType.missed,
//         DateTime.now().subtract(const Duration(hours: 5))),
//     CallLog('0934567890', CallType.outgoing,
//         DateTime.now().subtract(const Duration(days: 1, hours: 3))),
//     CallLog('0978123456', CallType.missed,
//         DateTime.now().subtract(const Duration(days: 2))),
//     CallLog('0963456789', CallType.incoming,
//         DateTime.now().subtract(const Duration(days: 3))),
//   ];

//   // Getters
//   String get dialNumber => _dialNumber;
//   PhoneRightView get rightView => _rightView;
//   bool get isCalling => _isCalling;
//   bool get speakerOn => _speakerOn;
//   bool get isHold => _isHold;
//   bool get showSidePad => _showSidePad;
//   bool get micOn => _micOn;
//   List<Contact> get contacts => _mockContacts;
//   List<CallLog> get callLogs => _callLogs;

//   // Methods
//   void addDigit(String digit) {
//     _dialNumber += digit;
//     notifyListeners();
//   }

//   void deleteLastDigit() {
//     if (_dialNumber.isNotEmpty) {
//       _dialNumber = _dialNumber.substring(0, _dialNumber.length - 1);
//       notifyListeners();
//     }
//   }

//   void clearDialNumber() {
//     _dialNumber = '';
//     notifyListeners();
//   }

//   void setRightView(PhoneRightView view) {
//     _rightView = view;
//     notifyListeners();
//   }

//   void startCall() {
//     if (_dialNumber.isNotEmpty) {
//       _isCalling = true;
//       _showSidePad = false;
//       notifyListeners();
//     }
//   }

//   void endCall() {
//     _isCalling = false;
//     _showSidePad = false;
//     _dialNumber = '';
//     _speakerOn = false;
//     _isHold = false;
//     _micOn = true;
//     notifyListeners();
//   }

//   void toggleSpeaker() {
//     _speakerOn = !_speakerOn;
//     notifyListeners();
//   }

//   void toggleHold() {
//     _isHold = !_isHold;
//     notifyListeners();
//   }

//   void toggleSidePad() {
//     _showSidePad = !_showSidePad;
//     notifyListeners();
//   }

//   void toggleMic() {
//     _micOn = !_micOn;
//     notifyListeners();
//   }

//   void callFromContact(String number) {
//     _dialNumber = number;
//     notifyListeners();
//   }

//   // Helper method to get contact name from number
//   String? getContactName(String number) {
//     try {
//       final contact = _mockContacts.firstWhere((c) => c.number == number);
//       return contact.name;
//     } catch (e) {
//       return null;
//     }
//   }

//   // Helper method to get contact initial
//   String getContactInitial(String number) {
//     final name = getContactName(number);
//     if (name != null && name.isNotEmpty) {
//       return name[0].toUpperCase();
//     }
//     return '#';
//   }
// }
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/call_log.dart';
import '../models/enums.dart';

class PhoneViewModel extends ChangeNotifier {
  String _dialNumber = '';
  PhoneRightView _rightView = PhoneRightView.contacts;
  bool _isCalling = false;
  bool _speakerOn = false;
  bool _isHold = false;
  bool _showSidePad = false;
  bool _micOn = true;
  bool _showContacts = false;

  // Mock data
  final List<Contact> _mockContacts = [
    const Contact(name: 'Nguyễn Văn An', number: '0901234567'),
    const Contact(name: 'Trần Thị Bình', number: '0912345678'),
    const Contact(name: 'Lê Hoàng Long', number: '0987654321'),
    const Contact(name: 'Phạm Minh Tuấn', number: '0934567890'),
    const Contact(name: 'Đặng Quốc Huy', number: '0978123456'),
    const Contact(name: 'Hoàng Gia Bảo', number: '0963456789'),
    const Contact(name: 'Võ Thanh Tùng', number: '0945678123'),
    const Contact(name: 'Bùi Thị Lan', number: '0926789345'),
  ];

  final List<CallLog> _callLogs = [
    CallLog('0901234567', CallType.outgoing,
        DateTime.now().subtract(const Duration(minutes: 15))),
    CallLog('0912345678', CallType.incoming,
        DateTime.now().subtract(const Duration(hours: 2))),
    CallLog('0987654321', CallType.missed,
        DateTime.now().subtract(const Duration(hours: 5))),
    CallLog('0934567890', CallType.outgoing,
        DateTime.now().subtract(const Duration(days: 1, hours: 3))),
    CallLog('0978123456', CallType.missed,
        DateTime.now().subtract(const Duration(days: 2))),
    CallLog('0963456789', CallType.incoming,
        DateTime.now().subtract(const Duration(days: 3))),
  ];

  // Getters
  String get dialNumber => _dialNumber;
  PhoneRightView get rightView => _rightView;
  bool get isCalling => _isCalling;
  bool get speakerOn => _speakerOn;
  bool get isHold => _isHold;
  bool get showSidePad => _showSidePad;
  bool get micOn => _micOn;
  bool get showContacts => _showContacts;
  List<Contact> get contacts => _mockContacts;
  List<CallLog> get callLogs => _callLogs;

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
    if (_dialNumber.isNotEmpty) {
      _isCalling = true;
      _showSidePad = false;
      _showContacts = false;
      notifyListeners();
    }
  }

  void endCall() {
    _isCalling = false;
    _showSidePad = false;
    _dialNumber = '';
    _speakerOn = false;
    _isHold = false;
    _micOn = true;
    _showContacts = false;
    notifyListeners();
  }

  void toggleSpeaker() {
    _speakerOn = !_speakerOn;
    notifyListeners();
  }

  void toggleHold() {
    _isHold = !_isHold;
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

  // Helper method to get contact name from number
  String? getContactName(String number) {
    try {
      final contact = _mockContacts.firstWhere((c) => c.number == number);
      return contact.name;
    } catch (e) {
      return null;
    }
  }

  // Helper method to get contact initial
  String getContactInitial(String number) {
    final name = getContactName(number);
    if (name != null && name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '#';
  }
}
