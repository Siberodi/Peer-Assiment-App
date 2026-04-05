import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../data/datasources/remote/groups_source_service.dart';
import '../../data/repositories/groups_repository.dart';
import '../viewmodels/groups_controller.dart';

class TeacherGroupMembersPage extends StatefulWidget {
  final String groupCode;
  final String groupName;

  const TeacherGroupMembersPage({
    super.key,
    required this.groupCode,
    required this.groupName,
  });

  @override
  State<TeacherGroupMembersPage> createState() => _TeacherGroupMembersPageState();
}

class _TeacherGroupMembersPageState extends State<TeacherGroupMembersPage> {
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
      tag: 'group_members_${widget.groupCode}',
    );

    final accessToken = authController.accessToken;

    if (accessToken != null) {
      groupsController.loadStudentsByGroup(
        groupCode: widget.groupCode,
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
        title: Text(widget.groupName),
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

        if (groupsController.students.isEmpty) {
          return const Center(
            child: Text('No hay estudiantes en este grupo'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupsController.students.length,
          itemBuilder: (context, index) {
            final student = groupsController.students[index];

            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(student.studentName),
                subtitle: Text(student.studentEmail),
              ),
            );
          },
        );
      }),
    );
  }
}