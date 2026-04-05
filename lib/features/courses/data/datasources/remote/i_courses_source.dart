abstract class ICoursesSource {
  Future<List<Map<String, dynamic>>> getTeacherCourses(
    String teacherEmail,
    String accessToken,
  );

  Future<List<Map<String, dynamic>>> getStudentCourses(
    String studentEmail,
    String accessToken,
  );
}