import 'package:dio/dio.dart';
import 'i_assessments_source.dart';

class AssessmentsSourceService implements IAssessmentsSource {
  final Dio dio;
  final String databaseBaseUrl;

  bool get _isMockApi => databaseBaseUrl.contains('mockapi.com');

  AssessmentsSourceService({
    required this.dio,
    required this.databaseBaseUrl,
  });

  @override
  Future<void> createAssessment({
    required String accessToken,
    required String assessmentName,
    required String courseCode,
    required String courseName,
    required String teacherEmail,
    required bool visibility,
    required String startAt,
    required String endAt,
    required bool status,
  }) async {
    if (_isMockApi) {
      return;
    }

    final parsedCourseCode = int.tryParse(courseCode);

    final record = {
      'AssessmentName': assessmentName,
      'CourseCode': parsedCourseCode ?? courseCode,
      'CourseName': courseName,
      'TeacherEmail': teacherEmail,
      'Visibility': visibility,
      'StartAt': startAt,
      'EndAt': endAt,
      'Status': status,
      'CreatedAt': DateTime.now().toIso8601String(),
    };

    try {
      final response = await dio.post(
        '$databaseBaseUrl/insert',
        data: {
          'tableName': 'Assessments',
          'records': [record],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final inserted = response.data['inserted'] as List<dynamic>? ?? [];
      final skipped = response.data['skipped'] as List<dynamic>? ?? [];

      if (inserted.isEmpty && skipped.isNotEmpty) {
        throw Exception('ROBLE omitió la inserción: $skipped');
      }

      if (inserted.isEmpty) {
        throw Exception('ROBLE no devolvió registros insertados');
      }

      await dio.get(
        '$databaseBaseUrl/read',
        queryParameters: {
          'tableName': 'Assessments',
          'TeacherEmail': teacherEmail,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? 'Error creando evaluación');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTeacherAssessments({
    required String accessToken,
    required String teacherEmail,
  }) async {
    if (_isMockApi) {
      return [];
    }

    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'Assessments',
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
  Future<List<Map<String, dynamic>>> getStudentAssessments({
    required String accessToken,
    required String courseCode,
    required String groupCode,
  }) async {
    if (_isMockApi) {
      return [];
    }

    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'Assessments',
        'CourseCode': int.tryParse(courseCode) ?? courseCode,
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
  Future<void> submitAssessmentResponses({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {
    if (_isMockApi) {
      return;
    }

    final response = await dio.post(
      '$databaseBaseUrl/insert',
      data: {
        'tableName': 'AssessmentResponses',
        'records': records,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Error enviando respuestas');
    }
  }

  @override
  Future<bool> hasStudentSubmittedAssessment({
    required String accessToken,
    required String assessmentId,
    required String evaluatorEmail,
  }) async {
    if (_isMockApi) {
      return false;
    }

    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'AssessmentResponses',
        'AssessmentId': assessmentId,
        'EvaluatorEmail': evaluatorEmail,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    final List<dynamic> data = response.data;
    return data.isNotEmpty;
  }

  @override
  Future<List<Map<String, dynamic>>> getAssessmentResponses({
    required String accessToken,
    required String assessmentId,
  }) async {
    if (_isMockApi) {
      return [];
    }

    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'AssessmentResponses',
        'AssessmentId': assessmentId,
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
  Future<List<Map<String, dynamic>>> getGroupMembers({
    required String accessToken,
    required String groupCode,
  }) async {
    if (_isMockApi) {
      return [];
    }

    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'GroupMembers',
        'GroupCode': groupCode,
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
  Future<void> publishAssessmentResults({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {
    if (_isMockApi) {
      return;
    }

    final response = await dio.post(
      '$databaseBaseUrl/insert',
      data: {
        'tableName': 'AssessmentResults',
        'records': records,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Error publicando resultados');
    }
  }
}
