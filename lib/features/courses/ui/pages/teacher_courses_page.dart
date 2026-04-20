import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../../controllers/authentication_controller.dart';
import '../../../../core/shared_preferences_service.dart';
import '../../data/datasources/local/courses_cache_source.dart';
import '../../data/datasources/remote/courses_source_service.dart';
import '../../data/repositories/courses_repository.dart';
import '../viewmodels/courses_controller.dart';
import '../../../groups/ui/pages/teacher_course_groups_page.dart';

class TeacherCoursesPage extends StatefulWidget {
  const TeacherCoursesPage({super.key});

  @override
  State<TeacherCoursesPage> createState() => _TeacherCoursesPageState();
}

class _TeacherCoursesPageState extends State<TeacherCoursesPage> {
  late final CoursesController coursesController;
  final AuthenticationController authController = Get.find();

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenLight = Color(0xFFCAEDC0);
  static const Color background = Color(0xFFF3F3F3);
  static const Color subtitleColor = Color(0xFF5E738B);

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
      tag: 'teacher_courses',
    );

    final teacherEmail = authController.currentUser.value?.email;
    final accessToken = authController.accessToken;

    if (teacherEmail != null && accessToken != null) {
      coursesController.loadTeacherCourses(
        teacherEmail: teacherEmail,
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
          height: 210,
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 16,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  iconSize: 34,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const Center(
                child: Text(
                  'Mi cursos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
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

  Widget buildCourseCard(dynamic course) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => TeacherCourseGroupsPage(
            courseCode: course.courseCode,
            courseName: course.courseName,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 26),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        decoration: BoxDecoration(
          color: greenLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseName,
                    style: const TextStyle(
                      color: greenDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Código: ${course.courseCode}',
                    style: const TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: greenDark,
              size: 38,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return const Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No tienes cursos registrados todavía',
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
        if (coursesController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: greenDark,
            ),
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

        return Column(
          children: [
            buildHeader(),
            const SizedBox(height: 30),
            if (coursesController.courses.isEmpty)
              buildEmptyState()
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: coursesController.courses.length,
                  itemBuilder: (context, index) {
                    final course = coursesController.courses[index];
                    return buildCourseCard(course);
                  },
                ),
              ),
          ],
        );
      }),
    );
  }
}