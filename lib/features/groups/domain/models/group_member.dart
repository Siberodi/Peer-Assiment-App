class GroupMember {
  final String id;
  final String courseCode;
  final String groupCode;
  final String groupName;
  final String studentEmail;
  final String studentName;
  final String teacherEmail;
  final String createdAt;

  GroupMember({
    required this.id,
    required this.courseCode,
    required this.groupCode,
    required this.groupName,
    required this.studentEmail,
    required this.studentName,
    required this.teacherEmail,
    required this.createdAt,
  });
}