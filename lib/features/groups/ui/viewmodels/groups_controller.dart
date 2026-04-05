import 'package:get/get.dart';
import '../../domain/models/group.dart';
import '../../domain/models/group_member.dart';
import '../../domain/repositories/i_groups_repository.dart';

class GroupsController extends GetxController {
  final IGroupsRepository repository;

  GroupsController({required this.repository});

  final RxList<Group> groups = <Group>[].obs;
  final RxList<GroupMember> students = <GroupMember>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadGroupsByCourse({
    required String courseCode,
    required String accessToken,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getGroupsByCourse(
        courseCode,
        accessToken,
      );

      groups.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStudentsByGroup({
    required String groupCode,
    required String accessToken,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getStudentsByGroup(
        groupCode,
        accessToken,
      );

      students.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  final RxList<GroupMember> studentGroups = <GroupMember>[].obs;

  Future<void> loadStudentGroupsByCourse({
    required String courseCode,
    required String studentEmail,
    required String accessToken,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getStudentGroupsByCourse(
        courseCode,
        studentEmail,
        accessToken,
      );

      studentGroups.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  Future<int> getPeerCountForGroup({
    required String groupCode,
    required String studentEmail,
    required String accessToken,
  }) async {
    final members = await repository.getStudentsByGroup(
      groupCode,
      accessToken,
    );

    final peers = members.where((member) {
      return member.studentEmail.trim().toLowerCase() !=
          studentEmail.trim().toLowerCase();
    }).toList();

    return peers.length;
  }
}