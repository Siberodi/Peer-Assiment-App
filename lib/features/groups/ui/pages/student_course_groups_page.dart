import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/core/shared_preferences_service.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/local/groups_cache_source.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/remote/groups_source_service.dart';
import 'package:peer_assiment_app_1/features/groups/data/repositories/groups_repository.dart';
import 'package:peer_assiment_app_1/features/groups/ui/viewmodels/groups_controller.dart';
import 'package:peer_assiment_app_1/features/groups/ui/pages/student_group_members_page.dart';

class StudentCourseGroupsPage extends StatefulWidget {
  final String courseCode;
  final String courseName;

  const StudentCourseGroupsPage({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  State<StudentCourseGroupsPage> createState() =>
      _StudentCourseGroupsPageState();
}

class _StudentCourseGroupsPageState extends State<StudentCourseGroupsPage> {
  late final GroupsController groupsController;
  final AuthenticationController authController = Get.find();

  @override
  void initState() {
    super.initState();

    final source = GroupsSourceService(
      dio: Dio(),
      databaseBaseUrl: authController.databaseBaseUrl,
      authController: authController,
    );

    final cacheSource = GroupsCacheSource(
      SharedPreferencesService(),
    );

    final repository = GroupsRepository(
      source: source,
      cacheSource: cacheSource,
    );

    groupsController = Get.put(
      GroupsController(repository: repository),
      tag: 'student_groups_${widget.courseCode}',
    );

    final accessToken = authController.accessToken;
    final studentEmail = authController.currentUser.value?.email;

    if (accessToken != null && studentEmail != null) {
      groupsController.loadStudentGroupsByCourse(
        courseCode: widget.courseCode,
        studentEmail: studentEmail,
        accessToken: accessToken,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);
    const background = Color(0xFFF3F3F3);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(widget.courseName),
        backgroundColor: greenDark,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (groupsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (groupsController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                groupsController.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (groupsController.studentGroups.isEmpty) {
          return const Center(
            child: Text('No perteneces a grupos en este curso'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupsController.studentGroups.length,
          itemBuilder: (context, index) {
            final group = groupsController.studentGroups[index];

            return FutureBuilder<int>(
              future: groupsController.getPeerCountForGroup(
                groupCode: group.groupCode,
                studentEmail: authController.currentUser.value?.email ?? '',
                accessToken: authController.accessToken ?? '',
              ),
              builder: (context, peerSnapshot) {
                final peerCount = peerSnapshot.data ?? 0;

                return Card(
                  child: ListTile(
                    title: Text(group.groupName),
                    subtitle: Text(
                      'Código: ${group.groupCode} • $peerCount compañeros',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Get.to(
                        () => StudentGroupMembersPage(
                          groupCode: group.groupCode,
                          groupName: group.groupName,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}