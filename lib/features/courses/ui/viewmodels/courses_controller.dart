import 'package:get/get.dart';
import 'package:peer_assiment_app_1/features/courses/domain/models/course.dart';
import 'package:peer_assiment_app_1/features/courses/domain/repositories/i_courses_repository.dart';

class CoursesController extends GetxController {
  final ICoursesRepository repository;

  CoursesController({required this.repository});

  final RxList<Course> courses = <Course>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> loadTeacherCourses({
    required String teacherEmail,
    required String accessToken,
    bool forceRefresh = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getTeacherCourses(
        teacherEmail,
        accessToken,
        forceRefresh: forceRefresh,
      );

      courses.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStudentCourses({
    required String studentEmail,
    required String accessToken,
    bool forceRefresh = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getStudentCourses(
        studentEmail,
        accessToken,
        forceRefresh: forceRefresh,
      );

      courses.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}