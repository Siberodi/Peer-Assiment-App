class Assessment {
  final String id;
  final String assessmentName;
  final String courseCode;
  final String courseName;
  final String groupCode;
  final String groupName;
  final String teacherEmail;
  final bool visibility;
  final String startAt;
  final String endAt;
  final bool status;
  final String createdAt;

  Assessment({
    required this.id,
    required this.assessmentName,
    required this.courseCode,
    required this.courseName,
    required this.groupCode,
    required this.groupName,
    required this.teacherEmail,
    required this.visibility,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.createdAt,
  });

  factory Assessment.fromMap(Map<String, dynamic> map) {
    return Assessment(
      id: map['_id']?.toString() ?? '',
      assessmentName: map['AssessmentName']?.toString() ?? '',
      courseCode: map['CourseCode']?.toString() ?? '',
      courseName: map['CourseName']?.toString() ?? '',
      groupCode: map['GroupCode']?.toString() ?? '',
      groupName: map['GroupName']?.toString() ?? '',
      teacherEmail: map['TeacherEmail']?.toString() ?? '',
      visibility: map['Visibility'] == true,
      startAt: map['StartAt']?.toString() ?? '',
      endAt: map['EndAt']?.toString() ?? '',
      status: map['Status'] == true,
      createdAt: map['CreatedAt']?.toString() ?? '',
    );
  }
}