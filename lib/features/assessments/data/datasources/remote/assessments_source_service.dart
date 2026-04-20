import 'package:dio/dio.dart' as d;
import '../../../../../controllers/authentication_controller.dart';
import 'i_assessments_source.dart';

class AssessmentsSourceService implements IAssessmentsSource {
  final d.Dio dioClient;
  final String databaseBaseUrl;
  final AuthenticationController authController;

  bool get _isMockApi => databaseBaseUrl.contains('mockapi.com');

  AssessmentsSourceService({
    required this.dioClient,
    required this.databaseBaseUrl,
    required this.authController,
  });

  Future<d.Response<dynamic>> _authorizedGet(
    String path, {
    required String accessToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dioClient.get(
        path,
        queryParameters: queryParameters,
        options: d.Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on d.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await authController.refreshAccessToken();

        if (!refreshed) {
          await authController.signOut();
          throw Exception('Sesión expirada. Inicia sesión nuevamente.');
        }

        final newToken = authController.accessToken;
        if (newToken == null || newToken.isEmpty) {
          throw Exception('No se pudo obtener un nuevo token');
        }

        return await dioClient.get(
          path,
          queryParameters: queryParameters,
          options: d.Options(
            headers: {
              'Authorization': 'Bearer $newToken',
            },
          ),
        );
      }

      rethrow;
    }
  }

  Future<d.Response<dynamic>> _authorizedPost(
    String path, {
    required String accessToken,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dioClient.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: d.Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on d.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await authController.refreshAccessToken();

        if (!refreshed) {
          await authController.signOut();
          throw Exception('Sesión expirada. Inicia sesión nuevamente.');
        }

        final newToken = authController.accessToken;
        if (newToken == null || newToken.isEmpty) {
          throw Exception('No se pudo obtener un nuevo token');
        }

        return await dioClient.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: d.Options(
            headers: {
              'Authorization': 'Bearer $newToken',
            },
          ),
        );
      }

      rethrow;
    }
  }

  Future<d.Response<dynamic>> _authorizedDelete(
    String path, {
    required String accessToken,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dioClient.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: d.Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on d.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await authController.refreshAccessToken();

        if (!refreshed) {
          await authController.signOut();
          throw Exception('Sesión expirada. Inicia sesión nuevamente.');
        }

        final newToken = authController.accessToken;
        if (newToken == null || newToken.isEmpty) {
          throw Exception('No se pudo obtener un nuevo token');
        }

        return await dioClient.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: d.Options(
            headers: {
              'Authorization': 'Bearer $newToken',
            },
          ),
        );
      }

      rethrow;
    }
  }

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
    if (_isMockApi) return;

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
      final response = await _authorizedPost(
        '$databaseBaseUrl/insert',
        accessToken: accessToken,
        data: {
          'tableName': 'Assessments',
          'records': [record],
        },
      );

      final inserted = response.data['inserted'] as List<dynamic>? ?? [];
      final skipped = response.data['skipped'] as List<dynamic>? ?? [];

      if (inserted.isEmpty && skipped.isNotEmpty) {
        throw Exception('ROBLE omitió la inserción: $skipped');
      }

      if (inserted.isEmpty) {
        throw Exception('ROBLE no devolvió registros insertados');
      }

      await _authorizedGet(
        '$databaseBaseUrl/read',
        accessToken: accessToken,
        queryParameters: {
          'tableName': 'Assessments',
          'TeacherEmail': teacherEmail,
        },
      );
    } on d.DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? 'Error creando evaluación',
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTeacherAssessments({
    required String accessToken,
    required String teacherEmail,
  }) async {
    if (_isMockApi) return [];

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'Assessments',
        'TeacherEmail': teacherEmail,
      },
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
    if (_isMockApi) return [];

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'Assessments',
        'CourseCode': int.tryParse(courseCode) ?? courseCode,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<void> submitAssessmentResponses({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {
    if (_isMockApi) return;

    final response = await _authorizedPost(
      '$databaseBaseUrl/insert',
      accessToken: accessToken,
      data: {
        'tableName': 'AssessmentResponses',
        'records': records,
      },
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
    if (_isMockApi) return false;

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'AssessmentResponses',
        'AssessmentId': assessmentId,
        'EvaluatorEmail': evaluatorEmail,
      },
    );

    final List<dynamic> data = response.data;
    return data.isNotEmpty;
  }

  @override
  Future<List<Map<String, dynamic>>> getAssessmentResponses({
    required String accessToken,
    required String assessmentId,
  }) async {
    if (_isMockApi) return [];

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'AssessmentResponses',
        'AssessmentId': assessmentId,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getGroupMembers({
    required String accessToken,
    required String groupCode,
  }) async {
    if (_isMockApi) return [];

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'GroupMembers',
        'GroupCode': groupCode,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<void> publishAssessmentResults({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {
    if (_isMockApi) return;

    try {
      final response = await _authorizedPost(
        '$databaseBaseUrl/insert',
        accessToken: accessToken,
        data: {
          'tableName': 'AssessmentResults',
          'records': records,
        },
      );

      final data = response.data;
      final inserted =
          data is Map ? (data['inserted'] as List<dynamic>? ?? []) : [];
      final skipped =
          data is Map ? (data['skipped'] as List<dynamic>? ?? []) : [];

      if (inserted.isEmpty && skipped.isNotEmpty) {
        throw Exception('ROBLE omitió la inserción: $skipped');
      }

      if (inserted.isEmpty) {
        throw Exception('ROBLE no devolvió resultados insertados');
      }
    } on d.DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Error publicando resultados',
      );
    }
  }

  @override
  Future<void> deleteAssessmentResults({
    required String accessToken,
    required String assessmentId,
  }) async {
    if (_isMockApi) return;

    final existingResponse = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'AssessmentResults',
        'AssessmentId': assessmentId,
      },
    );

    final List<dynamic> existing = existingResponse.data;

    if (existing.isEmpty) return;

    final ids = existing
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => e['_id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();

    if (ids.isEmpty) return;

    final response = await _authorizedDelete(
      '$databaseBaseUrl/delete',
      accessToken: accessToken,
      data: {
        'tableName': 'AssessmentResults',
        'ids': ids,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error eliminando resultados previos');
    }
  }
}