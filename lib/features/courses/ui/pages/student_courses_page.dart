import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../../controllers/authentication_controller.dart';
import '../../../../core/shared_preferences_service.dart';
import '../../data/datasources/local/courses_cache_source.dart';
import '../../data/datasources/remote/courses_source_service.dart';
import '../../data/repositories/courses_repository.dart';
import '../viewmodels/courses_controller.dart';
import '../../../groups/ui/pages/student_course_groups_page.dart';

class StudentCoursesPage extends StatefulWidget {
  const StudentCoursesPage({super.key});

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  late final CoursesController coursesController;
  final AuthenticationController authController = Get.find();

  @override
  void initState() {
    super.initState();

    final source = CoursesSourceService(
      dio: Dio(),
      databaseBaseUrl: authController.databaseBaseUrl,
    );

    final localPreferences = SharedPreferencesService();
    final cacheSource = CoursesCacheSource(localPreferences);

    final repository = CoursesRepository(
      source: source,
      cacheSource: cacheSource,
    );

    coursesController = Get.put(
      CoursesController(repository: repository),
      tag: 'student_courses',
    );

    final studentEmail = authController.currentUser.value?.email;
    final accessToken = authController.accessToken;

    if (studentEmail != null && accessToken != null) {
      coursesController.loadStudentCourses(
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
        title: const Text('Mis Cursos'),
        backgroundColor: greenDark,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (coursesController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (coursesController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                coursesController.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (coursesController.courses.isEmpty) {
          return const Center(
            child: Text('No perteneces a cursos todavía'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: coursesController.courses.length,
          itemBuilder: (context, index) {
            final course = coursesController.courses[index];

            return Card(
              child: ListTile(
                title: Text(course.courseName),
                subtitle: Text('Código: ${course.courseCode}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.to(
                    () => StudentCourseGroupsPage(
                      courseCode: course.courseCode,
                      courseName: course.courseName,
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}