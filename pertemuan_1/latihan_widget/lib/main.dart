// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Hello Flutter!',
//               style: TextStyle(
//                   fontSize: 40, fontWeight: FontWeight.w900, color: Colors.deepPurple),
//             ),
//             SizedBox(height: 8),
//             Text('Ini teks biasa dengan ukuran kecil',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ));
// }


import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Container(
          // 1. Mengubah width dan height ke 300x100
          width: 300,
          height: 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            // 2. Mengubah BorderRadius.circular(20) -> (100)
            borderRadius: BorderRadius.circular(100),
            // 4. Menambahkan border di dalam BoxDecoration
            border: Border.all(color: Colors.black, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                // 3. Mengubah blurRadius ke 50
                blurRadius: 50,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Text('Box',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
        ),
      ),
    ),
  ));
}