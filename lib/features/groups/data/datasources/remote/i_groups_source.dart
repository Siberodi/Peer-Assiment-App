abstract class IGroupsSource {
  Future<List<Map<String, dynamic>>> getGroupsByCourse(
    String courseCode,
    String accessToken,
  );

  Future<List<Map<String, dynamic>>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  );
  Future<List<Map<String, dynamic>>> getStudentGroupsByCourse(
  String courseCode,
  String studentEmail,
  String accessToken,
);
}
