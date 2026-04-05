import '../models/group.dart';
import '../models/group_member.dart';

abstract class IGroupsRepository {
  Future<List<Group>> getGroupsByCourse(
    String courseCode,
    String accessToken,
  );

  Future<List<GroupMember>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  );
  
  Future<List<GroupMember>> getStudentGroupsByCourse(
  String courseCode,
  String studentEmail,
  String accessToken,
  );
}