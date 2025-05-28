import 'package:hive/hive.dart';
import 'dart:convert';

part 'section_model.g.dart';

@HiveType(typeId: 1)
class SectionModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int courseId;

  @HiveField(2)
  final String instructorName; // Changed from professor to match API

  @HiveField(3)
  final Map<String, dynamic> times;

  @HiveField(4)
  final List<String> classes;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final DateTime? examTime;

  @HiveField(7)
  final int capacity; // Added to match API

  SectionModel({
    required this.id,
    required this.courseId,
    required this.instructorName,
    Map<String, dynamic>? times,
    List<String>? classes,
    String? description,
    this.examTime,
    required this.capacity,
  })  : times = times ?? {},
        classes = classes ?? [],
        description = description ?? '';

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    // Support both nested and flat JSON structures
    final sectionData = json['section'] as Map<String, dynamic>? ?? json;

    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      }
      if (value is String) {
        return [value];
      }
      return [];
    }

    Map<String, dynamic> parseTimes(dynamic value) {
      if (value == null) return {};
      try {
        if (value is Map) {
          return Map<String, dynamic>.from(value);
        }
        if (value is String) {
          // Try parsing string as JSON if provided
          return Map<String, dynamic>.from(
              jsonDecode(value) as Map<String, dynamic>? ?? {});
        }
      } catch (e) {
        print('Error parsing times: $e');
      }
      return {};
    }

    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      try {
        return DateTime.tryParse(value.toString());
      } catch (e) {
        print('Error parsing datetime: $e');
        return null;
      }
    }

    int parseIntSafely(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return SectionModel(
      id: parseIntSafely(sectionData['id']),
      courseId: parseIntSafely(sectionData['course_id']),
      instructorName: sectionData['instructor_name']?.toString() ?? '',
      times: parseTimes(sectionData['times']),
      classes: parseStringList(sectionData['classes']),
      description: sectionData['description']?.toString() ?? '',
      examTime: parseDateTime(sectionData['exam_datetime']),
      capacity: parseIntSafely(sectionData['capacity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'instructor_name': instructorName,
      'times': times,
      'classes': classes,
      'description': description,
      'exam_datetime': examTime?.toIso8601String(),
      'capacity': capacity,
    };
  }
}
