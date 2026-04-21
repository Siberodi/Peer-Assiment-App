import 'package:peer_assiment_app_1/features/courses/domain/models/course.dart';

abstract class ICoursesRepository {
  Future<List<Course>> getTeacherCourses(
    String teacherEmail,
    String accessToken, {
    bool forceRefresh = false,
  });

  Future<List<Course>> getStudentCourses(
    String studentEmail,
    String accessToken, {
    bool forceRefresh = false,
  });
}