import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../../controllers/authentication_controller.dart';
import '../../../../core/shared_preferences_service.dart';
import '../../data/datasources/local/groups_cache_source.dart';
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
  State<TeacherGroupMembersPage> createState() =>
      _TeacherGroupMembersPageState();
}

class _TeacherGroupMembersPageState
    extends State<TeacherGroupMembersPage> {
  late final GroupsController groupsController;
  final AuthenticationController authController = Get.find();

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenLight = Color(0xFFCAEDC0);
  static const Color background = Color(0xFFF3F3F3);
  static const Color subtitleColor = Color(0xFF5E738B);

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

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8ED973), greenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 200,
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 16,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    widget.groupName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStudentCard(dynamic student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: greenLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(27),
            ),
            child: const Icon(
              Icons.person,
              color: greenDark,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.studentName,
                  style: const TextStyle(
                    color: greenDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  student.studentEmail,
                  style: const TextStyle(
                    color: subtitleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return const Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No hay estudiantes en este grupo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: greenDark,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Obx(() {
        if (groupsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: greenDark,
            ),
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

        return Column(
          children: [
            buildHeader(),
            const SizedBox(height: 28),
            if (groupsController.students.isEmpty)
              buildEmptyState()
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  itemCount: groupsController.students.length,
                  itemBuilder: (context, index) {
                    final student = groupsController.students[index];
                    return buildStudentCard(student);
                  },
                ),
              ),
          ],
        );
      }),
    );
  }
}