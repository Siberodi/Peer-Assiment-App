import 'package:dio/dio.dart';
import 'i_assessments_source.dart';

class AssessmentsSourceService implements IAssessmentsSource {
  final Dio dio;
  final String databaseBaseUrl;

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

  print('ASSESSMENT RECORD => $record');

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

    print('ASSESSMENT INSERT RESPONSE => ${response.data}');

    final inserted = response.data['inserted'] as List<dynamic>? ?? [];
    final skipped = response.data['skipped'] as List<dynamic>? ?? [];

    if (inserted.isEmpty && skipped.isNotEmpty) {
      throw Exception('ROBLE omitió la inserción: $skipped');
    }

    if (inserted.isEmpty) {
      throw Exception('ROBLE no devolvió registros insertados');
    }

    final readResponse = await dio.get(
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

    print('ASSESSMENT READ AFTER INSERT => ${readResponse.data}');
  } on DioException catch (e) {
    print('ASSESSMENT INSERT STATUS => ${e.response?.statusCode}');
    print('ASSESSMENT INSERT ERROR DATA => ${e.response?.data}');
    throw Exception(e.response?.data.toString() ?? 'Error creando evaluación');
  } catch (e) {
    print('ASSESSMENT INSERT GENERAL ERROR => $e');
    rethrow;
  }
}

  @override
  Future<List<Map<String, dynamic>>> getTeacherAssessments({
    required String accessToken,
    required String teacherEmail,
  }) async {
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
  await dio.post(
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
}
@override
Future<bool> hasStudentSubmittedAssessment({
  required String accessToken,
  required String assessmentId,
  required String evaluatorEmail,
}) async {
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
  await dio.post(
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
}

}