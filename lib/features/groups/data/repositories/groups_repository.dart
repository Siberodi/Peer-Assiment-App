import 'package:peer_assiment_app_1/features/groups/domain/models/group.dart';
import 'package:peer_assiment_app_1/features/groups/domain/models/group_member.dart';
import 'package:peer_assiment_app_1/features/groups/domain/repositories/i_groups_repository.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/local/i_groups_cache_source.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/remote/i_groups_source.dart';

class GroupsRepository implements IGroupsRepository {
  final IGroupsSource source;
  final IGroupsCacheSource cacheSource;

  GroupsRepository({
    required this.source,
    required this.cacheSource,
  });

  Group _mapToGroup(Map<String, dynamic> item) {
    return Group(
      id: item['_id']?.toString() ?? '',
      courseCode: item['CourseCode']?.toString() ?? '',
      groupCode: item['GroupCode']?.toString() ?? '',
      groupName: item['GroupName']?.toString() ?? '',
      teacherEmail: item['TeacherEmail']?.toString() ?? '',
      createdAt: item['CreatedAt']?.toString() ?? '',
    );
  }

  GroupMember _mapToGroupMember(Map<String, dynamic> item) {
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
  }

  @override
  Future<List<Group>> getGroupsByCourse(
    String courseCode,
    String accessToken, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        await cacheSource.isGroupsByCourseCacheValid(courseCode)) {
      final cached = await cacheSource.getCachedGroupsByCourse(courseCode);
      return cached.map(_mapToGroup).toList();
    }

    final data = await source.getGroupsByCourse(courseCode, accessToken);
    await cacheSource.cacheGroupsByCourse(courseCode, data);

    return data.map(_mapToGroup).toList();
  }

  @override
  Future<List<GroupMember>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  ) async {
    final data = await source.getStudentsByGroup(groupCode, accessToken);
    return data.map(_mapToGroupMember).toList();
  }

  @override
  Future<List<GroupMember>> getStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    String accessToken, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        await cacheSource.isStudentGroupsByCourseCacheValid(
          courseCode,
          studentEmail,
        )) {
      final cached = await cacheSource.getCachedStudentGroupsByCourse(
        courseCode,
        studentEmail,
      );
      return cached.map(_mapToGroupMember).toList();
    }

    final data = await source.getStudentGroupsByCourse(
      courseCode,
      studentEmail,
      accessToken,
    );

    await cacheSource.cacheStudentGroupsByCourse(
      courseCode,
      studentEmail,
      data,
    );

    return data.map(_mapToGroupMember).toList();
  }
}
