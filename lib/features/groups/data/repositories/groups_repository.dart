import '../../domain/models/group.dart';
import '../../domain/models/group_member.dart';
import '../../domain/repositories/i_groups_repository.dart';
import '../datasources/remote/i_groups_source.dart';

class GroupsRepository implements IGroupsRepository {
  final IGroupsSource source;

  GroupsRepository({required this.source});

  @override
  Future<List<Group>> getGroupsByCourse(
    String courseCode,
    String accessToken,
  ) async {
    final data = await source.getGroupsByCourse(courseCode, accessToken);

    return data.map((item) {
      return Group(
        id: item['_id']?.toString() ?? '',
        courseCode: item['CourseCode']?.toString() ?? '',
        groupCode: item['GroupCode']?.toString() ?? '',
        groupName: item['GroupName']?.toString() ?? '',
        teacherEmail: item['TeacherEmail']?.toString() ?? '',
        createdAt: item['CreatedAt']?.toString() ?? '',
      );
    }).toList();
  }

  @override
  Future<List<GroupMember>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  ) async {
    final data = await source.getStudentsByGroup(groupCode, accessToken);

    return data.map((item) {
      return GroupMember(
        id: item['_id']?.toString() ?? '',
        courseCode: item['CourseCode']?.toString() ?? '',
        groupCode: item['GroupCode']?.toString() ?? '',
        groupName: item['GroupName']?.toString() ?? '',
        studentEmail: item['StudentEmail']?.toString() ?? '',
        studentName: item['StudentName']?.toString() ?? '',
        teacherEmail: item['TeacherEmail']?.toString() ?? '',
        createdAt: item['CreatedAt']?.toString() ?? '',
      );
    }).toList();
  }

  @override
  Future<List<GroupMember>> getStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    String accessToken,
  ) async {
    final data = await source.getStudentGroupsByCourse(
      courseCode,
      studentEmail,
      accessToken,
    );

    return data.map((item) {
      return GroupMember(
        id: item['_id']?.toString() ?? '',
        courseCode: item['CourseCode']?.toString() ?? '',
        groupCode: item['GroupCode']?.toString() ?? '',
        groupName: item['GroupName']?.toString() ?? '',
        studentEmail: item['StudentEmail']?.toString() ?? '',
        studentName: item['StudentName']?.toString() ?? '',
        teacherEmail: item['TeacherEmail']?.toString() ?? '',
        createdAt: item['CreatedAt']?.toString() ?? '',
      );
    }).toList();
  }
}