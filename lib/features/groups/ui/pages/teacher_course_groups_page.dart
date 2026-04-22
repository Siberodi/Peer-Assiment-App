import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/core/shared_preferences_service.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/local/groups_cache_source.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/remote/groups_source_service.dart';
import 'package:peer_assiment_app_1/features/groups/data/repositories/groups_repository.dart';
import 'package:peer_assiment_app_1/features/groups/ui/viewmodels/groups_controller.dart';
import 'package:peer_assiment_app_1/features/groups/ui/pages/teacher_group_members_page.dart';

import 'package:peer_assiment_app_1/features/assessments/ui/pages/create_assessment_page.dart';
import 'package:peer_assiment_app_1/features/assessments/data/datasources/remote/assessments_source_service.dart';
import 'package:peer_assiment_app_1/features/assessments/data/repositories/assessments_repository.dart';
import 'package:peer_assiment_app_1/features/assessments/ui/viewmodels/assessments_controller.dart';
import 'package:peer_assiment_app_1/features/assessments/ui/pages/teacher_assessment_results_page.dart';

class TeacherCourseGroupsPage extends StatefulWidget {
  final String courseCode;
  final String courseName;

  const TeacherCourseGroupsPage({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  State<TeacherCourseGroupsPage> createState() =>
      _TeacherCourseGroupsPageState();
}

class _TeacherCourseGroupsPageState extends State<TeacherCourseGroupsPage> {
  late final GroupsController groupsController;
  late final AssessmentsController assessmentsController;
  final AuthenticationController authController = Get.find();
  String get _groupsControllerTag => 'teacher_groups_${widget.courseCode}';
  String get _assessmentsControllerTag =>
      'course_assessments_${widget.courseCode}';

  int selectedTab = 0;

  static const Color greenDark = Color(0xFF577F49);
  static const Color greenLight = Color(0xFFB9DDAF);
  static const Color greenHeaderLight = Color(0xFF8ED973);
  static const Color greenHeaderDark = Color(0xFF4F7E43);
  static const Color background = Color(0xFFF3F3F3);
  static const Color blueGreyText = Color(0xFF5E738B);

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<GroupsController>(tag: _groupsControllerTag)) {
      groupsController = Get.find<GroupsController>(tag: _groupsControllerTag);
    } else {
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
        tag: _groupsControllerTag,
      );
    }

    if (Get.isRegistered<AssessmentsController>(
      tag: _assessmentsControllerTag,
    )) {
      assessmentsController = Get.find<AssessmentsController>(
        tag: _assessmentsControllerTag,
      );
    } else {
      final assessmentsSource = AssessmentsSourceService(
        dioClient: Dio(),
        databaseBaseUrl: authController.databaseBaseUrl,
        authController: authController,
      );
      final assessmentsRepository = AssessmentsRepository(
        source: assessmentsSource,
      );

      assessmentsController = Get.put(
        AssessmentsController(repository: assessmentsRepository),
        tag: _assessmentsControllerTag,
      );
    }

    final accessToken = authController.accessToken;
    final teacherEmail = authController.currentUser.value?.email;

    if (accessToken != null) {
      groupsController.loadGroupsByCourse(
        courseCode: widget.courseCode,
        accessToken: accessToken,
        forceRefresh: true,
      );

      if (teacherEmail != null) {
        assessmentsController.loadTeacherAssessments(
          accessToken: accessToken,
          teacherEmail: teacherEmail,
        );
      }
    }
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [greenHeaderLight, greenHeaderDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.white,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.courseName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCreateButton() {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => CreateAssessmentPage(
            courseCode: widget.courseCode,
            courseName: widget.courseName,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: greenDark),
        ),
        child: const Center(
          child: Text(
            'Crear evaluación para este curso',
            style: TextStyle(
              color: greenDark,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = 0;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selectedTab == 0 ? greenDark : greenLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Evaluaciones',
                  style: TextStyle(
                    color: selectedTab == 0 ? Colors.white : greenDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = 1;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selectedTab == 1 ? greenDark : greenLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Grupos',
                  style: TextStyle(
                    color: selectedTab == 1 ? Colors.white : greenDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAssessmentCard(dynamic a) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => TeacherAssessmentResultsPage(
            assessmentId: a.id,
            assessmentName: a.assessmentName,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: greenLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              a.assessmentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: greenDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              a.status ? 'Activa' : 'Cerrada',
              style: TextStyle(
                fontSize: 15,
                color: a.status ? blueGreyText : Colors.red.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGroupCard(dynamic group) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => TeacherGroupMembersPage(
            groupCode: group.groupCode,
            groupName: group.groupName,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: greenLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: greenDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Código: ${group.groupCode}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: blueGreyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: greenDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Obx(() {
      final courseAssessments = assessmentsController.assessments
          .where((a) => a.courseCode == widget.courseCode)
          .toList();

      if (selectedTab == 0) {
        if (courseAssessments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                'No hay evaluaciones aún',
                style: TextStyle(fontSize: 15),
              ),
            ),
          );
        }

        return Column(
          children: courseAssessments.map(buildAssessmentCard).toList(),
        );
      }

      if (groupsController.groups.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'No hay grupos en este curso',
              style: TextStyle(fontSize: 15),
            ),
          ),
        );
      }

      return Column(
        children: groupsController.groups.map(buildGroupCard).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
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

        return Column(
          children: [
            buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildCreateButton(),
                    const SizedBox(height: 18),
                    buildTabs(),
                    const SizedBox(height: 22),
                    buildContent(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
