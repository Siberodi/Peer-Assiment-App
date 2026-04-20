import 'dart:convert';

import '../../../../../core/i_local_preferences.dart';
import 'i_courses_cache_source.dart';

class CoursesCacheSource implements ICoursesCacheSource {
  final ILocalPreferences prefs;

  static const int _cacheTTLMinutes = 60;

  CoursesCacheSource(this.prefs);

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  String _teacherCoursesKey(String teacherEmail) =>
      'teacher_courses_${_normalizeEmail(teacherEmail)}';

  String _teacherCoursesTimestampKey(String teacherEmail) =>
      'teacher_courses_${_normalizeEmail(teacherEmail)}_timestamp';

  String _studentCoursesKey(String studentEmail) =>
      'student_courses_${_normalizeEmail(studentEmail)}';

  String _studentCoursesTimestampKey(String studentEmail) =>
      'student_courses_${_normalizeEmail(studentEmail)}_timestamp';

  @override
  Future<bool> isTeacherCoursesCacheValid(String teacherEmail) async {
    try {
      final timestampStr =
          await prefs.getString(_teacherCoursesTimestampKey(teacherEmail));
      if (timestampStr == null) return false;

      final timestamp = DateTime.parse(timestampStr);
      final difference = DateTime.now().difference(timestamp).inMinutes;

      return difference < _cacheTTLMinutes;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> cacheTeacherCourses(
    String teacherEmail,
    List<Map<String, dynamic>> courses,
  ) async {
    final encoded = jsonEncode(courses);

    await prefs.setString(_teacherCoursesKey(teacherEmail), encoded);
    await prefs.setString(
      _teacherCoursesTimestampKey(teacherEmail),
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedTeacherCourses(
    String teacherEmail,
  ) async {
    try {
      final encoded = await prefs.getString(_teacherCoursesKey(teacherEmail));

      if (encoded == null || encoded.isEmpty) {
        throw Exception('No teacher courses cache found');
      }

      final decoded = jsonDecode(encoded) as List;
      return decoded
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      await clearTeacherCoursesCache(teacherEmail);
      throw Exception('Failed to read teacher courses cache');
    }
  }

  @override
  Future<void> clearTeacherCoursesCache(String teacherEmail) async {
    await prefs.remove(_teacherCoursesKey(teacherEmail));
    await prefs.remove(_teacherCoursesTimestampKey(teacherEmail));
  }

  @override
  Future<bool> isStudentCoursesCacheValid(String studentEmail) async {
    try {
      final timestampStr =
          await prefs.getString(_studentCoursesTimestampKey(studentEmail));
      if (timestampStr == null) return false;

      final timestamp = DateTime.parse(timestampStr);
      final difference = DateTime.now().difference(timestamp).inMinutes;

      return difference < _cacheTTLMinutes;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> cacheStudentCourses(
    String studentEmail,
    List<Map<String, dynamic>> courses,
  ) async {
    final encoded = jsonEncode(courses);

    await prefs.setString(_studentCoursesKey(studentEmail), encoded);
    await prefs.setString(
      _studentCoursesTimestampKey(studentEmail),
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedStudentCourses(
    String studentEmail,
  ) async {
    try {
      final encoded = await prefs.getString(_studentCoursesKey(studentEmail));

      if (encoded == null || encoded.isEmpty) {
        throw Exception('No student courses cache found');
      }

      final decoded = jsonDecode(encoded) as List;
      return decoded
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      await clearStudentCoursesCache(studentEmail);
      throw Exception('Failed to read student courses cache');
    }
  }

  @override
  Future<void> clearStudentCoursesCache(String studentEmail) async {
    await prefs.remove(_studentCoursesKey(studentEmail));
    await prefs.remove(_studentCoursesTimestampKey(studentEmail));
  }
}