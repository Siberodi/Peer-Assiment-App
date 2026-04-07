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
  try {
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
    return await repository.getAssessmentResponses(
      accessToken: accessToken,
      assessmentId: assessmentId,
    );
  } catch (e) {
    errorMessage.value = e.toString();
    return [];
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
}