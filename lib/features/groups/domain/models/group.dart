class Group {
  final String id;
  final String courseCode;
  final String groupCode;
  final String groupName;
  final String teacherEmail;
  final String createdAt;

  Group({
    required this.id,
    required this.courseCode,
    required this.groupCode,
    required this.groupName,
    required this.teacherEmail,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      courseCode: json['CourseCode']?.toString() ?? '',
      groupCode: json['GroupCode']?.toString() ?? '',
      groupName: json['GroupName']?.toString() ?? '',
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
      'TeacherEmail': teacherEmail,
      'CreatedAt': createdAt,
    };
  }
}