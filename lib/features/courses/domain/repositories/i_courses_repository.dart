import '../models/course.dart';

abstract class ICoursesRepository {
  Future<List<Course>> getTeacherCourses(
    String teacherEmail,
    String accessToken,
  );

  Future<List<Course>> getStudentCourses(
    String studentEmail,
    String accessToken,
  );
}