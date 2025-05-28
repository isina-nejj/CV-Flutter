// import 'package:flutter/material.dart';
// import '../../services/hive_service.dart';

// class ChartPage extends StatefulWidget {
//   final HiveService hiveService;

//   const ChartPage({
//     super.key,
//     required this.hiveService,
//   });

//   @override
//   State<ChartPage> createState() => _ChartPageState();
// }

// class _ChartPageState extends State<ChartPage> {
//   Future<List<Map<String, dynamic>>>? _coursesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadCourses();
//   }

//   Future<void> _loadCourses() async {
//     _coursesFuture = _fetchCoursesFromCache();
//   }

//   Future<List<Map<String, dynamic>>> _fetchCoursesFromCache() async {
//     try {
//       final courses = await widget.hiveService.getCourses();
//       return courses;
//     } catch (e) {
//       print('Error loading courses from cache: $e');
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final termColors = [
//       Colors.red.shade100,
//       Colors.blue.shade100,
//       Colors.green.shade100,
//       Colors.yellow.shade100,
//       Colors.orange.shade100,
//       Colors.purple.shade100,
//       Colors.teal.shade100,
//       Colors.pink.shade100,
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('انتخاب دروس'),
//         actions: [
//           // اضافه کردن دکمه رفرش برای به‌روزرسانی دستی
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _loadCourses();
//               });
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _coursesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text('خطا در بارگذاری دروس: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('هیچ درسی یافت نشد.'));
//           }

//           final courses = snapshot.data!;

//           // Group courses by term (assuming term is derived from course ID)
//           final terms = List.generate(8, (index) => <Map<String, dynamic>>[]);
//           for (final course in courses) {
//             final termIndex = (course['id'] ~/ 100) - 1;
//             if (termIndex >= 0 && termIndex < 8) {
//               terms[termIndex].add(course);
//             }
//           }

//           return ListView.builder(
//             itemCount: terms.length,
//             itemBuilder: (context, termIndex) {
//               final termCourses = terms[termIndex];

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'ترم ${termIndex + 1}',
//                       style: const TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     reverse: true, // Start scrolled to the right
//                     child: Row(
//                       children: termCourses.map((course) {
//                         return Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                           decoration: BoxDecoration(
//                             color: termColors[termIndex % termColors.length],
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   course['name'] ??
//                                       course['course_name'] ??
//                                       'درس ناشناخته',
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8.0),
//                                 Text('${course['units'] ?? 0} واحد'),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0), // Add spacing between terms
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
