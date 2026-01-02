// import 'package:flutter/material.dart';

// class SpeedGauge extends StatelessWidget {
//   final double speed; // Tốc độ hiện tại
//   final String gear; // Số (P, R, N, D)
//   final bool leftSignal; // Xi nhan trái
//   final bool rightSignal; // Xi nhan phải

//   const SpeedGauge({
//     super.key,
//     required this.speed,
//     required this.gear,
//     required this.leftSignal,
//     required this.rightSignal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 250,
//       height: 250,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.black.withOpacity(0.6),
//         border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 3),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.cyanAccent.withOpacity(0.2),
//               blurRadius: 20,
//               spreadRadius: 5),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // 1. Khu vực Xi-nhan
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.arrow_back,
//                   color:
//                       leftSignal ? Colors.green : Colors.grey.withOpacity(0.2),
//                   size: 30),
//               const SizedBox(width: 40),
//               Icon(Icons.arrow_forward,
//                   color:
//                       rightSignal ? Colors.green : Colors.grey.withOpacity(0.2),
//                   size: 30),
//             ],
//           ),

//           const SizedBox(height: 10),

//           // 2. Số to đùng
//           Text(
//             speed.toInt().toString(),
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 80,
//                 fontWeight: FontWeight.w200,
//                 height: 1.0),
//           ),
//           const Text("km/h",
//               style: TextStyle(
//                   color: Colors.cyanAccent, fontSize: 16, letterSpacing: 2)),

//           const SizedBox(height: 20),

//           // 3. Hộp số (P R N D)
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             decoration: BoxDecoration(
//                 color: Colors.white10, borderRadius: BorderRadius.circular(20)),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: ["P", "R", "N", "D"].map((g) {
//                 final isActive = g == gear;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     g,
//                     style: TextStyle(
//                       color: isActive
//                           ? (g == "P" ? Colors.red : Colors.greenAccent)
//                           : Colors.grey,
//                       fontWeight:
//                           isActive ? FontWeight.bold : FontWeight.normal,
//                       fontSize: isActive ? 20 : 16,
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
