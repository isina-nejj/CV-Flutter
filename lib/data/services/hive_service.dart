// import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/section_model.dart';
import '../services/api_service.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  // باکس‌های Hive
  late Box coursesBox;
  late Box sectionsBox;
  late Box lastUpdateBox;

  Future<void> init() async {
    try {
      print('Initializing HiveService...');
      coursesBox = Hive.box('courses');
      print(
          'Courses box initialized: ${coursesBox.name}, length: ${coursesBox.length}');
      sectionsBox = Hive.box('sections');
      print('Sections box initialized');
      lastUpdateBox = Hive.box('lastUpdate');
      print('Last update box initialized');
      print('HiveService initialization complete');
    } catch (e) {
      print('Error in init: $e');
      throw e;
    }
  }

  // دریافت همه داده‌ها
  Future<Map<String, dynamic>> getAllData() async {
    try {
      print('Getting all data...');
      print('Courses box length: ${coursesBox.length}');
      print('Courses box keys: ${coursesBox.keys.toList()}');
      print('Sections box length: ${sectionsBox.length}');
      print('Sections box keys: ${sectionsBox.keys.toList()}');

      // Get course_map from coursesBox
      final courseMap =
          Map<String, dynamic>.from(coursesBox.get('course_map') ?? {});

      // Convert sections to properly typed Map<String, dynamic>
      final sections = sectionsBox.values
          .whereType<SectionModel>()
          .map((e) => Map<String, dynamic>.from(e.toJson()))
          .toList();

      final result = {
        'course_map': courseMap,
        'sections': sections,
      };

      print('Final result: $result');
      return result;
    } catch (e, stackTrace) {
      print('Error in getAllData: $e');
      print('Stack trace: $stackTrace');
      throw e;
    }
  }

  // ذخیره داده‌های دریافتی از سرور
  Future<void> saveServerData(Map<String, dynamic> data) async {
    try {
      print('Starting to save server data');

      // Save course_map
      if (data.containsKey('course_map')) {
        await coursesBox.put('course_map', data['course_map']);
        print('Course map saved');
      }

      // Save sections if present
      if (data.containsKey('sections')) {
        await sectionsBox.clear();
        final sections =
            List<Map<String, dynamic>>.from(data['sections'] as List);
        for (var sectionData in sections) {
          final sectionModel = SectionModel.fromJson(sectionData);
          await sectionsBox.add(sectionModel);
        }
        print('Sections saved');
      }

      await updateLastUpdateTime();
      print('Server data saved successfully');
    } catch (e, stackTrace) {
      print('Error in saveServerData: $e');
      print('Stack trace: $stackTrace');
      throw e;
    }
  }

  // بروزرسانی سکشن
  Future<void> updateSection(Map<String, dynamic> section) async {
    final sectionModel = SectionModel.fromJson(section);
    await sectionsBox.put(sectionModel.id, sectionModel);
  }

  // اضافه کردن سکشن جدید
  Future<void> addSection(Map<String, dynamic> section) async {
    final sectionModel = SectionModel.fromJson(section);
    await sectionsBox.add(sectionModel);
  }

  // حذف سکشن
  Future<void> deleteSection(String id) async {
    await sectionsBox.delete(id);
  }

  // بروزرسانی زمان آخرین بروزرسانی
  Future<void> updateLastUpdateTime() async {
    await lastUpdateBox.put('lastUpdate', DateTime.now().toIso8601String());
  }

  // چک کردن نیاز به بروزرسانی
  Future<bool> needsRefresh() async {
    final lastUpdate = lastUpdateBox.get('lastUpdate');
    if (lastUpdate == null) return true;

    final lastUpdateTime = DateTime.parse(lastUpdate);
    final now = DateTime.now();
    return now.difference(lastUpdateTime) > const Duration(hours: 24);
  }

  Future<DateTime?> getLastUpdateTime() async {
    final lastUpdateBox = await Hive.box('lastUpdate');
    final timestamp = lastUpdateBox.get('timestamp');
    if (timestamp != null) {
      return DateTime.parse(timestamp);
    }
    return null;
  }

  // دریافت یک سکشن با شناسه
  Future<Map<String, dynamic>?> getSection(String sectionId) async {
    try {
      print('Getting section with ID: $sectionId');
      // تلاش برای تبدیل ID به int
      int? intId;
      try {
        intId = int.parse(sectionId);
      } catch (e) {
        print('Error parsing section ID to int: $e');
      }

      // اول با String ID تلاش می‌کنیم
      var sectionModel = sectionsBox.get(sectionId);
      // اگر پیدا نشد، با int ID تلاش می‌کنیم
      if (sectionModel == null && intId != null) {
        sectionModel = sectionsBox.get(intId);
      }
      if (sectionModel != null) {
        if (sectionModel is SectionModel) {
          final result = sectionModel.toJson();
          // Ensure times is always an array
          if (result['times'] == null ||
              (result['times'] is Map && (result['times'] as Map).isEmpty)) {
            result['times'] = [];
          } else if (result['times'] is! List) {
            result['times'] = [result['times']];
          }
          print('Section found (after normalization): $result');
          return result;
        } else {
          print('Invalid section type: ${sectionModel.runtimeType}');
        }
      } else {
        print('No section found with ID: $sectionId');
      }
      return null;
    } catch (e) {
      print('Error getting section: $e');
      rethrow;
    }
  }

  // ذخیره یا به‌روزرسانی یک سکشن
  Future<void> saveSection(String sectionId, Map<String, dynamic> data) async {
    try {
      print('Saving section with ID: $sectionId, data: $data');

      // مطمئن میشیم که ID در data با sectionId سازگار هست
      if (data['id'] == null) {
        data['id'] =
            int.tryParse(sectionId) ?? DateTime.now().millisecondsSinceEpoch;
      } else if (data['id'] is String) {
        data['id'] = int.tryParse(data['id'] as String) ??
            int.tryParse(sectionId) ??
            DateTime.now().millisecondsSinceEpoch;
      }

      final sectionModel = SectionModel.fromJson(data);

      // ذخیره با ID عددی
      await sectionsBox.put(sectionModel.id, sectionModel);
      print('Section saved successfully. ID: ${sectionModel.id}');
    } catch (e) {
      print('Error saving section: $e');
      rethrow;
    }
  }

  /// ذخیره‌سازی سکشن در سرور و سپس در کش
  Future<void> saveSectionWithSync(
      String sectionId, Map<String, dynamic> data) async {
    try {
      print('Starting synchronized section save...');
      Map<String, dynamic> serverResponse = {};
      bool shouldCreate = true;

      if (data['id'] != null) {
        try {
          // Try update first if we have an ID
          print('Attempting to update section with ID: ${data['id']}');
          serverResponse =
              await ApiService.updateSection(int.parse(data['id']), data);
          shouldCreate = false;
        } on ApiException catch (e) {
          if (e.statusCode == 404) {
            // Section not found, will try create instead
            print('Section not found, will create new instead');
          } else {
            rethrow;
          }
        }
      }

      if (shouldCreate) {
        // Create new section
        var createData = Map<String, dynamic>.from(data);
        createData.remove('id'); // Remove ID for creation
        print('Creating new section');
        serverResponse = await ApiService.insertSection(createData);
        print('New section created successfully');
      }

      // Update local data with server response
      var updatedData = Map<String, dynamic>.from(data);
      if (serverResponse.containsKey('section_id')) {
        updatedData['id'] = serverResponse['section_id'].toString();
        print('Got section ID from server: ${updatedData['id']}');
      }

      // Save to cache
      final finalSectionId = updatedData['id']?.toString() ?? sectionId;
      await saveSection(finalSectionId, updatedData);
      print('Section saved in cache with ID: $finalSectionId');

      await updateLastUpdateTime();
    } on ApiException catch (e) {
      print('API error in sync save: ${e.message}');
      if (e.statusCode == 400) {
        throw Exception('Invalid section data: ${e.message}');
      }
      throw Exception('Failed to save section: ${e.message}');
    } catch (e) {
      print('Error in sync save: $e');
      throw Exception('Failed to sync section: $e');
    }
  }

  /// به‌روزرسانی سکشن در سرور و سپس در کش
  Future<void> updateSectionWithSync(
      String sectionId, Map<String, dynamic> updatedData) async {
    try {
      print('Starting synchronized section update...');

      // اول در سرور به‌روزرسانی می‌کنیم
      final serverResponse =
          await ApiService.updateSection(int.parse(sectionId), updatedData);

      print('Section updated on server successfully');

      // اطلاعات به‌روز شده را از پاسخ سرور دریافت می‌کنیم
      final finalData = Map<String, dynamic>.from(updatedData);
      if (serverResponse.containsKey('section_id')) {
        finalData['id'] = serverResponse['section_id'].toString();
      }

      // بعد از موفقیت در سرور، در کش به‌روزرسانی می‌کنیم
      await updateSection(finalData);
      print('Section updated in cache successfully');

      await updateLastUpdateTime();
    } on ApiException catch (e) {
      print('API error in synchronized section update: ${e.message}');
      if (e.statusCode == 404) {
        throw Exception('Section not found');
      } else if (e.statusCode == 400) {
        throw Exception('Invalid section data: ${e.message}');
      }
      throw Exception('Failed to update section on server: ${e.message}');
    } catch (e) {
      print('Error in synchronized section update: $e');
      throw Exception('Failed to sync section update: $e');
    }
  }

  /// حذف سکشن از سرور و کش
  Future<void> deleteSectionWithSync(String sectionId) async {
    try {
      print('Starting synchronized section delete...');

      // اول از سرور حذف می‌کنیم
      await ApiService.deleteSection(int.parse(sectionId));
      print('Section deleted from server successfully');

      // بعد از موفقیت در سرور، از کش حذف می‌کنیم
      await deleteSection(sectionId);
      print('Section deleted from cache successfully');

      await updateLastUpdateTime();
    } on ApiException catch (e) {
      print('API error in synchronized section delete: ${e.message}');
      if (e.statusCode == 404) {
        // اگر سکشن در سرور وجود نداشت، فقط از کش حذف می‌کنیم
        await deleteSection(sectionId);
        print('Section not found on server, deleted from cache');
      } else {
        throw Exception('Failed to delete section: ${e.message}');
      }
    } catch (e) {
      print('Error in synchronized section delete: $e');
      throw Exception('Failed to sync section delete: $e');
    }
  }
}
