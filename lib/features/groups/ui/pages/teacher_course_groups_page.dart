import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../data/datasources/remote/groups_source_service.dart';
import '../../data/repositories/groups_repository.dart';
import '../viewmodels/groups_controller.dart';
import 'teacher_group_members_page.dart';
import '../../../assessments/ui/pages/create_assessment_page.dart';
import '../../../assessments/data/datasources/remote/assessments_source_service.dart';
import '../../../assessments/data/repositories/assessments_repository.dart';
import '../../../assessments/ui/viewmodels/assessments_controller.dart';
import '../../../assessments/ui/pages/teacher_assessment_results_page.dart';

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

    final assessmentsSource = AssessmentsSourceService(
      dio: Dio(),
      databaseBaseUrl: authController.databaseBaseUrl,
    );

    final assessmentsRepository = AssessmentsRepository(
      source: assessmentsSource,
    );

    assessmentsController = Get.put(
      AssessmentsController(repository: assessmentsRepository),
      tag: 'course_assessments_${widget.courseCode}',
    );

    final accessToken = authController.accessToken;
    final teacherEmail = authController.currentUser.value?.email;

    if (accessToken != null) {
      groupsController.loadGroupsByCourse(
        courseCode: widget.courseCode,
        accessToken: accessToken,
      );

      if (teacherEmail != null) {
        assessmentsController.loadTeacherAssessments(
          accessToken: accessToken,
          teacherEmail: teacherEmail,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);
    const greenLight = Color(0xFF93D977);
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

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
  Get.to(() => CreateAssessmentPage(
        courseCode: widget.courseCode,
        courseName: widget.courseName,
      ));
},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: greenLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Crear evaluación para este curso',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Evaluaciones del curso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: greenDark,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Obx(() {
                final courseAssessments = assessmentsController.assessments
                    .where((a) => a.courseCode == widget.courseCode)
                    .toList();

                if (courseAssessments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('No hay evaluaciones aún'),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: courseAssessments.map((a) {
                      return Card(
  child: ListTile(
    title: Text(a.assessmentName),
    subtitle: Text(
      a.status ? 'Activa' : 'Cerrada',
      style: TextStyle(
        color: a.status ? Colors.green : Colors.red,
      ),
    ),
    trailing: const Icon(Icons.bar_chart), // más claro que assignment
    onTap: () {
      Get.to(() => TeacherAssessmentResultsPage(
            assessmentId: a.id,
            assessmentName: a.assessmentName,
          ));
    },
  ),
);
                    }).toList(),
                  ),
                );
              }),

              Expanded(
                child: groupsController.groups.isEmpty
                    ? const Center(
                        child: Text('No hay grupos en este curso'),
                      )
                    : ListView.builder(
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
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}