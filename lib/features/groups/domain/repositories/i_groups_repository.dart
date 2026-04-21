import 'package:get/get.dart';
import 'package:peer_assiment_app_1/features/groups/domain/models/group.dart';
import 'package:peer_assiment_app_1/features/groups/domain/models/group_member.dart';
import 'package:peer_assiment_app_1/features/groups/domain/repositories/i_groups_repository.dart';

abstract class IGroupsRepository {
  Future<List<Group>> getGroupsByCourse(
    String courseCode,
    String accessToken, {
    bool forceRefresh = false,
  });

  Future<List<GroupMember>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  );

  Future<List<GroupMember>> getStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    String accessToken, {
    bool forceRefresh = false,
  });
}