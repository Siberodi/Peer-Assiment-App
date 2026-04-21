abstract class ICoursesCacheSource {
  Future<bool> isTeacherCoursesCacheValid(String teacherEmail);

  Future<void> cacheTeacherCourses(
    String teacherEmail,
    List<Map<String, dynamic>> courses,
  );

  Future<List<Map<String, dynamic>>> getCachedTeacherCourses(
    String teacherEmail,
  );

  Future<void> clearTeacherCoursesCache(String teacherEmail);

  Future<bool> isStudentCoursesCacheValid(String studentEmail);

  Future<void> cacheStudentCourses(
    String studentEmail,
    List<Map<String, dynamic>> courses,
  );

  Future<List<Map<String, dynamic>>> getCachedStudentCourses(
    String studentEmail,
  );

  Future<void> clearStudentCoursesCache(String studentEmail);
}