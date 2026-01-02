// import 'enums.dart';

// class CallLog {
//   final String number;
//   final CallType type;
//   final DateTime dateTime;
//   final int duration; // Thời gian gọi tính bằng giây

//   CallLog(this.number, this.type, this.dateTime, {this.duration = 0});

//   // Factory để tạo từ JSON
//   factory CallLog.fromJson(Map<String, dynamic> json) {
//     return CallLog(
//       json['number'] as String,
//       CallType.values.firstWhere(
//         (e) => e.toString().split('.').last == json['type'],
//       ),
//       DateTime.parse(json['timestamp'] as String),
//       duration: json['duration'] as int? ?? 0,
//     );
//   }

//   // Chuyển sang JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'number': number,
//       'type': type.toString().split('.').last,
//       'timestamp': dateTime.toIso8601String(),
//       'duration': duration,
//     };
//   }

//   // Format thời gian cuộc gọi (mm:ss)
//   String get formattedDuration {
//     if (duration == 0) return '';
//     final minutes = duration ~/ 60;
//     final seconds = duration % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
// }
// import 'enums.dart';

// class CallLog {
//   final String number;
//   final CallType type;
//   final DateTime dateTime;

//   CallLog(this.number, this.type, this.dateTime);
// }
import 'enums.dart';

class CallLog {
  final String number;
  final CallType type;
  final DateTime dateTime;
  final int duration; // Thời gian gọi tính bằng giây

  CallLog(this.number, this.type, this.dateTime, {this.duration = 0});

  // Factory để tạo từ JSON
  factory CallLog.fromJson(Map<String, dynamic> json) {
    return CallLog(
      json['number'] as String,
      CallType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      DateTime.parse(json['timestamp'] as String),
      duration: json['duration'] as int? ?? 0,
    );
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'type': type.toString().split('.').last,
      'timestamp': dateTime.toIso8601String(),
      'duration': duration,
    };
  }

  // Format thời gian cuộc gọi (mm:ss)
  String get formattedDuration {
    if (duration == 0) return '';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
