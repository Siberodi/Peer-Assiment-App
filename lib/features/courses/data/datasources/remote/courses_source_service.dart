import 'package:dio/dio.dart';
import 'i_courses_source.dart';

class CoursesSourceService implements ICoursesSource {
  final Dio dio;
  final String databaseBaseUrl;

  bool get _isMockApi => databaseBaseUrl.contains('mockapi.com');

  CoursesSourceService({
    required this.dio,
    required this.databaseBaseUrl,
  });

  @override
  Future<List<Map<String, dynamic>>> getTeacherCourses(
    String teacherEmail,
    String accessToken,
  ) async {
    if (_isMockApi) {
      return [];
    }

    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'Courses',
        'TeacherEmail': teacherEmail,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getStudentCourses(
    String studentEmail,
    String accessToken,
  ) async {
    if (_isMockApi) {
      return [];
    }

    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'CourseStudents',
        'StudentEmail': studentEmail,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}