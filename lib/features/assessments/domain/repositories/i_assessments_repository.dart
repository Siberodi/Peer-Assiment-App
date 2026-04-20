import '../models/assessment.dart';

abstract class IAssessmentsRepository {
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
  });

  Future<List<Assessment>> getTeacherAssessments({
    required String accessToken,
    required String teacherEmail,
  });

  Future<List<Assessment>> getStudentAssessments({
    required String accessToken,
    required String courseCode,
    required String groupCode,
  });

  Future<void> submitAssessmentResponses({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  });

  Future<bool> hasStudentSubmittedAssessment({
    required String accessToken,
    required String assessmentId,
    required String evaluatorEmail,
  });

  Future<List<Map<String, dynamic>>> getAssessmentResponses({
    required String accessToken,
    required String assessmentId,
  });

  Future<List<Map<String, dynamic>>> getGroupMembers({
    required String accessToken,
    required String groupCode,
  });

  Future<void> publishAssessmentResults({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  });

  Future<void> replaceAssessmentResults({
    required String accessToken,
    required String assessmentId,
    required List<Map<String, dynamic>> records,
  });
}