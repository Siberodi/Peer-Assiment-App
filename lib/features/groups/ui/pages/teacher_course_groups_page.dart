import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../data/datasources/remote/groups_source_service.dart';
import '../../data/repositories/groups_repository.dart';
import '../viewmodels/groups_controller.dart';
import 'teacher_group_members_page.dart';

class TeacherCourseGroupsPage extends StatefulWidget {
  final String courseCode;
  final String courseName;

  const TeacherCourseGroupsPage({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  State<TeacherCourseGroupsPage> createState() => _TeacherCourseGroupsPageState();
}

class _TeacherCourseGroupsPageState extends State<TeacherCourseGroupsPage> {
  late final GroupsController groupsController;
  final AuthenticationController authController = Get.find();

  @override
  void initState() {
    super.initState();

    final source = GroupsSourceService(
      dio: Dio(),
      databaseBaseUrl: authController.databaseBaseUrl,
    );

    final repository = GroupsRepository(source: source);

    groupsController = Get.put(
      GroupsController(repository: repository),
      tag: 'teacher_groups_${widget.courseCode}',
    );

    final accessToken = authController.accessToken;

    if (accessToken != null) {
      groupsController.loadGroupsByCourse(
        courseCode: widget.courseCode,
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

        if (groupsController.groups.isEmpty) {
          return const Center(
            child: Text('No hay grupos en este curso'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupsController.groups.length,
          itemBuilder: (context, index) {
            final group = groupsController.groups[index];

            return Card(
              child: ListTile(
                title: Text(group.groupName),
                subtitle: Text('Código: ${group.groupCode}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.to(() => TeacherGroupMembersPage(
                        groupCode: group.groupCode,
                        groupName: group.groupName,
                      ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}