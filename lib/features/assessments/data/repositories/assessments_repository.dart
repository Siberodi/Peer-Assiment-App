import '../../domain/models/assessment.dart';
import '../../domain/repositories/i_assessments_repository.dart';
import '../datasources/remote/i_assessments_source.dart';

class AssessmentsRepository implements IAssessmentsRepository {
  final IAssessmentsSource source;

  AssessmentsRepository({required this.source});

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
    await source.createAssessment(
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
  }

  @override
  Future<List<Assessment>> getTeacherAssessments({
    required String accessToken,
    required String teacherEmail,
  }) async {
    final data = await source.getTeacherAssessments(
      accessToken: accessToken,
      teacherEmail: teacherEmail,
    );

    return data.map((e) => Assessment.fromMap(e)).toList();
  }

  @override
  Future<List<Assessment>> getStudentAssessments({
    required String accessToken,
    required String courseCode,
    required String groupCode,
  }) async {
    final data = await source.getStudentAssessments(
      accessToken: accessToken,
      courseCode: courseCode,
      groupCode: groupCode,
    );

    return data.map((e) => Assessment.fromMap(e)).toList();
  }
  @override
Future<void> submitAssessmentResponses({
  required String accessToken,
  required List<Map<String, dynamic>> records,
}) async {
  await source.submitAssessmentResponses(
    accessToken: accessToken,
    records: records,
  );
}
@override
Future<bool> hasStudentSubmittedAssessment({
  required String accessToken,
  required String assessmentId,
  required String evaluatorEmail,
}) async {
  return await source.hasStudentSubmittedAssessment(
    accessToken: accessToken,
    assessmentId: assessmentId,
    evaluatorEmail: evaluatorEmail,
  );
}
@override
Future<List<Map<String, dynamic>>> getAssessmentResponses({
  required String accessToken,
  required String assessmentId,
}) async {
  return await source.getAssessmentResponses(
    accessToken: accessToken,
    assessmentId: assessmentId,
  );
}

@override
Future<List<Map<String, dynamic>>> getGroupMembers({
  required String accessToken,
  required String groupCode,
}) async {
  return await source.getGroupMembers(
    accessToken: accessToken,
    groupCode: groupCode,
  );
}

@override
Future<void> publishAssessmentResults({
  required String accessToken,
  required List<Map<String, dynamic>> records,
}) async {
  await source.publishAssessmentResults(
    accessToken: accessToken,
    records: records,
  );
}
}