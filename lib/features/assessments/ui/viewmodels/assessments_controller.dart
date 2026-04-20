import 'package:get/get.dart';
import '../../domain/models/assessment.dart';
import '../../domain/repositories/i_assessments_repository.dart';

class AssessmentsController extends GetxController {
  final IAssessmentsRepository repository;

  AssessmentsController({required this.repository});

  final RxList<Assessment> assessments = <Assessment>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

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
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await repository.createAssessment(
        accessToken: accessToken,
        assessmentName: assessmentName,
        courseCode: courseCode,
        courseName: courseName,
        teacherEmail: teacherEmail,
        visibility: visibility,
        startAt: startAt,
        endAt: endAt,
        status: status,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTeacherAssessments({
    required String accessToken,
    required String teacherEmail,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getTeacherAssessments(
        accessToken: accessToken,
        teacherEmail: teacherEmail,
      );

      assessments.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStudentAssessments({
    required String accessToken,
    required String courseCode,
    required String groupCode,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getStudentAssessments(
        accessToken: accessToken,
        courseCode: courseCode,
        groupCode: groupCode,
      );

      assessments.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAssessmentResponses({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await repository.submitAssessmentResponses(
        accessToken: accessToken,
        records: records,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> hasStudentSubmittedAssessment({
    required String accessToken,
    required String assessmentId,
    required String evaluatorEmail,
  }) async {
    if (Get.testMode) return false;

    try {
      errorMessage.value = '';

      return await repository.hasStudentSubmittedAssessment(
        accessToken: accessToken,
        assessmentId: assessmentId,
        evaluatorEmail: evaluatorEmail,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAssessmentResponses({
    required String accessToken,
    required String assessmentId,
  }) async {
    try {
      errorMessage.value = '';

      return await repository.getAssessmentResponses(
        accessToken: accessToken,
        assessmentId: assessmentId,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getGroupMembers({
    required String accessToken,
    required String groupCode,
  }) async {
    try {
      errorMessage.value = '';

      return await repository.getGroupMembers(
        accessToken: accessToken,
        groupCode: groupCode,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      return [];
    }
  }

  Future<void> publishAssessmentResults({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await repository.publishAssessmentResults(
        accessToken: accessToken,
        records: records,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> replaceAssessmentResults({
    required String accessToken,
    required String assessmentId,
    required List<Map<String, dynamic>> records,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await repository.replaceAssessmentResults(
        accessToken: accessToken,
        assessmentId: assessmentId,
        records: records,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, Map<String, dynamic>> buildAverages(
    List<Map<String, dynamic>> responses,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final response in responses) {
      final email = response['EvaluatedEmail']?.toString() ?? '';
      if (email.isEmpty) continue;

      grouped.putIfAbsent(email, () => []);
      grouped[email]!.add(response);
    }

    final Map<String, Map<String, dynamic>> result = {};

    grouped.forEach((email, items) {
      final name = items.first['EvaluatedName']?.toString() ?? 'Sin nombre';

      double pAvg = 0;
      double cAvg = 0;
      double cmAvg = 0;
      double aAvg = 0;

      for (final item in items) {
        pAvg += ((item['p_score'] as num?) ?? 0).toDouble();
        cAvg += ((item['c_score'] as num?) ?? 0).toDouble();
        cmAvg += ((item['cm_score'] as num?) ?? 0).toDouble();
        aAvg += ((item['a_score'] as num?) ?? 0).toDouble();
      }

      final count = items.isEmpty ? 1 : items.length;
      pAvg /= count;
      cAvg /= count;
      cmAvg /= count;
      aAvg /= count;

      final generalAvg = (pAvg + cAvg + cmAvg + aAvg) / 4;

      result[email] = {
        'name': name,
        'pAvg': pAvg,
        'cAvg': cAvg,
        'cmAvg': cmAvg,
        'aAvg': aAvg,
        'generalAvg': generalAvg,
      };
    });

    return result;
  }

  Future<List<Map<String, dynamic>>> buildPublishableResults({
  required String accessToken,
  required String assessmentId,
}) async {
  errorMessage.value = '';

  final responses = await getAssessmentResponses(
    accessToken: accessToken,
    assessmentId: assessmentId,
  );

  if (responses.isEmpty) {
    throw Exception('No hay respuestas para publicar');
  }

  final assessment = assessments.firstWhereOrNull(
    (a) => a.id == assessmentId,
  );

  final assessmentName = assessment?.assessmentName ?? 'Evaluación';

  final Map<String, List<Map<String, dynamic>>> responsesByGroup = {};

  for (final response in responses) {
    final groupCode = response['GroupCode']?.toString() ?? '';
    if (groupCode.isEmpty) continue;

    responsesByGroup.putIfAbsent(groupCode, () => []);
    responsesByGroup[groupCode]!.add(response);
  }

  final List<Map<String, dynamic>> finalResults = [];

  for (final entry in responsesByGroup.entries) {
    final groupCode = entry.key;
    final groupResponses = entry.value;

    final members = await getGroupMembers(
      accessToken: accessToken,
      groupCode: groupCode,
    );

    final Map<String, List<Map<String, dynamic>>> byEvaluatedStudent = {};

    for (final response in groupResponses) {
      final email = response['EvaluatedEmail']?.toString() ?? '';
      if (email.isEmpty) continue;

      byEvaluatedStudent.putIfAbsent(email, () => []);
      byEvaluatedStudent[email]!.add(response);
    }

    for (final member in members) {
      final studentEmail = member['StudentEmail']?.toString() ?? '';
      if (studentEmail.isEmpty) continue;

      final memberCourseCode = member['CourseCode']?.toString() ?? '';
      if (memberCourseCode.isEmpty) continue;

      final items = byEvaluatedStudent[studentEmail] ?? [];

      double pAvg = 0;
      double cAvg = 0;
      double cmAvg = 0;
      double aAvg = 0;

      if (items.isNotEmpty) {
        for (final item in items) {
          pAvg += ((item['p_score'] as num?) ?? 0).toDouble();
          cAvg += ((item['c_score'] as num?) ?? 0).toDouble();
          cmAvg += ((item['cm_score'] as num?) ?? 0).toDouble();
          aAvg += ((item['a_score'] as num?) ?? 0).toDouble();
        }

        final count = items.length;
        pAvg /= count;
        cAvg /= count;
        cmAvg /= count;
        aAvg /= count;
      }

      final gAvg = (pAvg + cAvg + cmAvg + aAvg) / 4;

      finalResults.add({
        'AssessmentId': assessmentId,
        'AssessmentName': assessmentName,
        'StudentEmail': studentEmail,
        'GroupCode': groupCode,
        'CourseCode': int.tryParse(memberCourseCode) ?? memberCourseCode,
        'p_avg': pAvg,
        'c_avg': cAvg,
        'cm_avg': cmAvg,
        'a_avg': aAvg,
        'g_avg': gAvg,
        'Published': true,
        'CreatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  return finalResults;
}
}