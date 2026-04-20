import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../../controllers/authentication_controller.dart';
import '../../../../core/shared_preferences_service.dart';
import '../../data/datasources/local/groups_cache_source.dart';
import '../../data/datasources/remote/groups_source_service.dart';
import '../../data/repositories/groups_repository.dart';
import '../viewmodels/groups_controller.dart';

class StudentGroupMembersPage extends StatefulWidget {
  final String groupCode;
  final String groupName;

  const StudentGroupMembersPage({
    super.key,
    required this.groupCode,
    required this.groupName,
  });

  @override
  State<StudentGroupMembersPage> createState() =>
      _StudentGroupMembersPageState();
}

class _StudentGroupMembersPageState extends State<StudentGroupMembersPage> {
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

    final currentStudentEmail =
        authController.currentUser.value?.email.trim().toLowerCase() ?? '';

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

        final peers = groupsController.students.where((student) {
          return student.studentEmail.trim().toLowerCase() !=
              currentStudentEmail;
        }).toList();

        if (peers.isEmpty) {
          return const Center(
            child: Text('No tienes compañeros en este grupo'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: peers.length,
          itemBuilder: (context, index) {
            final peer = peers[index];

            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(peer.studentName),
                subtitle: Text(peer.studentEmail),
              ),
            );
          },
        );
      }),
    );
  }
}