import 'dart:convert';

import 'package:peer_assiment_app_1/core/i_local_preferences.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/local/ i_groups_cache_source.dart';

class GroupsCacheSource implements IGroupsCacheSource {
  final ILocalPreferences prefs;

  static const int _cacheTTLMinutes = 60;

  GroupsCacheSource(this.prefs);

  String _normalizeCourseCode(String courseCode) =>
      courseCode.trim().toLowerCase();

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  String _groupsByCourseKey(String courseCode) =>
      'groups_course_${_normalizeCourseCode(courseCode)}';

  String _groupsByCourseTimestampKey(String courseCode) =>
      'groups_course_${_normalizeCourseCode(courseCode)}_timestamp';

  String _studentGroupsByCourseKey(
    String courseCode,
    String studentEmail,
  ) =>
      'student_groups_${_normalizeCourseCode(courseCode)}_${_normalizeEmail(studentEmail)}';

  String _studentGroupsByCourseTimestampKey(
    String courseCode,
    String studentEmail,
  ) =>
      'student_groups_${_normalizeCourseCode(courseCode)}_${_normalizeEmail(studentEmail)}_timestamp';

  @override
  Future<bool> isGroupsByCourseCacheValid(String courseCode) async {
    try {
      final timestampStr =
          await prefs.getString(_groupsByCourseTimestampKey(courseCode));
      if (timestampStr == null) return false;

      final timestamp = DateTime.parse(timestampStr);
      final difference = DateTime.now().difference(timestamp).inMinutes;

      return difference < _cacheTTLMinutes;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> cacheGroupsByCourse(
    String courseCode,
    List<Map<String, dynamic>> groups,
  ) async {
    final encoded = jsonEncode(groups);

    await prefs.setString(_groupsByCourseKey(courseCode), encoded);
    await prefs.setString(
      _groupsByCourseTimestampKey(courseCode),
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedGroupsByCourse(
    String courseCode,
  ) async {
    try {
      final encoded = await prefs.getString(_groupsByCourseKey(courseCode));

      if (encoded == null || encoded.isEmpty) {
        throw Exception('No groups cache found');
      }

      final decoded = jsonDecode(encoded) as List;
      return decoded
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      await clearGroupsByCourseCache(courseCode);
      throw Exception('Failed to read groups cache');
    }
  }

  @override
  Future<void> clearGroupsByCourseCache(String courseCode) async {
    await prefs.remove(_groupsByCourseKey(courseCode));
    await prefs.remove(_groupsByCourseTimestampKey(courseCode));
  }

  @override
  Future<bool> isStudentGroupsByCourseCacheValid(
    String courseCode,
    String studentEmail,
  ) async {
    try {
      final timestampStr = await prefs.getString(
        _studentGroupsByCourseTimestampKey(courseCode, studentEmail),
      );
      if (timestampStr == null) return false;

      final timestamp = DateTime.parse(timestampStr);
      final difference = DateTime.now().difference(timestamp).inMinutes;

      return difference < _cacheTTLMinutes;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> cacheStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    List<Map<String, dynamic>> groups,
  ) async {
    final encoded = jsonEncode(groups);

    await prefs.setString(
      _studentGroupsByCourseKey(courseCode, studentEmail),
      encoded,
    );

    await prefs.setString(
      _studentGroupsByCourseTimestampKey(courseCode, studentEmail),
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
  ) async {
    try {
      final encoded = await prefs.getString(
        _studentGroupsByCourseKey(courseCode, studentEmail),
      );

      if (encoded == null || encoded.isEmpty) {
        throw Exception('No student groups cache found');
      }

      final decoded = jsonDecode(encoded) as List;
      return decoded
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      await clearStudentGroupsByCourseCache(courseCode, studentEmail);
      throw Exception('Failed to read student groups cache');
    }
  }

  @override
  Future<void> clearStudentGroupsByCourseCache(
    String courseCode,
    String studentEmail,
  ) async {
    await prefs.remove(_studentGroupsByCourseKey(courseCode, studentEmail));
    await prefs.remove(
      _studentGroupsByCourseTimestampKey(courseCode, studentEmail),
    );
  }
}