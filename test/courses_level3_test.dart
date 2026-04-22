import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mockito/mockito.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/auth/data/models/app_user.dart';
import 'package:peer_assiment_app_1/features/courses/data/datasources/local/i_courses_cache_source.dart';
import 'package:peer_assiment_app_1/features/courses/ui/viewmodels/courses_controller.dart';
import 'package:peer_assiment_app_1/features/courses/data/repositories/courses_repository.dart';
import 'package:peer_assiment_app_1/features/courses/data/datasources/remote/courses_source_service.dart';

class FakeDio extends Mock implements dio.Dio {
  bool shouldThrow = false;

  @override
  Future<dio.Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onReceiveProgress,
  }) async {
    if (shouldThrow) {
      throw dio.DioException(
        requestOptions: dio.RequestOptions(path: path),
        error: 'Network error',
      );
    }

    return dio.Response<T>(
      requestOptions: dio.RequestOptions(path: path),
      data: [
        {
          'CourseCode': 'course1',
          'CourseName': 'Test Course',
          'TeacherEmail': 'teacher@test.com',
          '_id': '1',
          'CreatedAt': '2024-01-01',
        }
      ] as T,
      statusCode: 200,
    );
  }
}

class FakeCoursesCacheSource implements ICoursesCacheSource {
  final Map<String, List<Map<String, dynamic>>> _teacherCourses = {};
  final Map<String, List<Map<String, dynamic>>> _studentCourses = {};

  @override
  Future<void> cacheStudentCourses(
    String studentEmail,
    List<Map<String, dynamic>> courses,
  ) async {
    _studentCourses[studentEmail] = courses;
  }

  @override
  Future<void> cacheTeacherCourses(
    String teacherEmail,
    List<Map<String, dynamic>> courses,
  ) async {
    _teacherCourses[teacherEmail] = courses;
  }

  @override
  Future<void> clearAllTeacherAndStudentCoursesCache() async {
    _teacherCourses.clear();
    _studentCourses.clear();
  }

  @override
  Future<void> clearStudentCoursesCache(String studentEmail) async {
    _studentCourses.remove(studentEmail);
  }

  @override
  Future<void> clearTeacherCoursesCache(String teacherEmail) async {
    _teacherCourses.remove(teacherEmail);
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedStudentCourses(
    String studentEmail,
  ) async {
    return _studentCourses[studentEmail] ?? [];
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedTeacherCourses(
    String teacherEmail,
  ) async {
    return _teacherCourses[teacherEmail] ?? [];
  }

  @override
  Future<bool> isStudentCoursesCacheValid(String studentEmail) async => false;

  @override
  Future<bool> isTeacherCoursesCacheValid(String teacherEmail) async => false;
}

void main() {
  late FakeDio fakeDio;
  late AuthenticationController authController;
  late CoursesController coursesController;

  setUp(() {
    Get.reset();
    Get.testMode = false;

    fakeDio = FakeDio();

    authController = AuthenticationController(dioClient: fakeDio);
    authController.currentUser.value = AppUser(
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    final source = CoursesSourceService(
      dio: fakeDio,
      databaseBaseUrl: 'https://test.com/database/test',
    );

    final repository = CoursesRepository(
      source: source,
      cacheSource: FakeCoursesCacheSource(),
    );

    coursesController = CoursesController(repository: repository);

    Get.put<AuthenticationController>(authController);
  });

  tearDown(() {
    Get.reset();
  });

  test('LoadTeacherCourses - success', () async {
    await coursesController.loadTeacherCourses(
      teacherEmail: 'teacher@test.com',
      accessToken: 'fake_token',
    );

    expect(coursesController.courses.length, 1);
    expect(coursesController.courses[0].courseCode, 'course1');
    expect(coursesController.errorMessage.value, '');
  });

  test('LoadTeacherCourses - error', () async {
    fakeDio.shouldThrow = true;

    await coursesController.loadTeacherCourses(
      teacherEmail: 'teacher@test.com',
      accessToken: 'fake_token',
    );

    expect(coursesController.errorMessage.value, isNotEmpty);
  });
}
