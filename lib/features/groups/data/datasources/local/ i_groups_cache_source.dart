abstract class IGroupsCacheSource {
  Future<bool> isGroupsByCourseCacheValid(String courseCode);

  Future<void> cacheGroupsByCourse(
    String courseCode,
    List<Map<String, dynamic>> groups,
  );

  Future<List<Map<String, dynamic>>> getCachedGroupsByCourse(
    String courseCode,
  );

  Future<void> clearGroupsByCourseCache(String courseCode);

  Future<bool> isStudentGroupsByCourseCacheValid(
    String courseCode,
    String studentEmail,
  );

  Future<void> cacheStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    List<Map<String, dynamic>> groups,
  );

  Future<List<Map<String, dynamic>>> getCachedStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
  );

  Future<void> clearStudentGroupsByCourseCache(
    String courseCode,
    String studentEmail,
  );

  Future<void> clearAllStudentGroupsCache();
}