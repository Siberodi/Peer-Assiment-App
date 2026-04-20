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

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      courseCode: json['CourseCode']?.toString() ?? '',
      groupCode: json['GroupCode']?.toString() ?? '',
      groupName: json['GroupName']?.toString() ?? '',
      studentEmail: json['StudentEmail']?.toString() ?? '',
      studentName: json['StudentName']?.toString() ?? '',
      teacherEmail: json['TeacherEmail']?.toString() ?? '',
      createdAt: json['CreatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'CourseCode': courseCode,
      'GroupCode': groupCode,
      'GroupName': groupName,
      'StudentEmail': studentEmail,
      'StudentName': studentName,
      'TeacherEmail': teacherEmail,
      'CreatedAt': createdAt,
    };
  }
}