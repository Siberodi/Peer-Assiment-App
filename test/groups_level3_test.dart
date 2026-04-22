import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mockito/mockito.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/auth/data/models/app_user.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/local/i_groups_cache_source.dart';
import 'package:peer_assiment_app_1/features/groups/ui/viewmodels/groups_controller.dart';
import 'package:peer_assiment_app_1/features/groups/data/repositories/groups_repository.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/remote/groups_source_service.dart';

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
          'GroupCode': 'group1',
          'GroupName': 'Test Group',
          'TeacherEmail': 'teacher@test.com',
          '_id': '1',
          'CreatedAt': '2024-01-01',
        }
      ] as T,
      statusCode: 200,
    );
  }
}

class FakeGroupsCacheSource implements IGroupsCacheSource {
  final Map<String, List<Map<String, dynamic>>> _groupsByCourse = {};
  final Map<String, List<Map<String, dynamic>>> _studentGroupsByCourse = {};

  String _studentKey(String courseCode, String studentEmail) =>
      '$courseCode|$studentEmail';

  @override
  Future<void> cacheGroupsByCourse(
    String courseCode,
    List<Map<String, dynamic>> groups,
  ) async {
    _groupsByCourse[courseCode] = groups;
  }

  @override
  Future<void> cacheStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    List<Map<String, dynamic>> groups,
  ) async {
    _studentGroupsByCourse[_studentKey(courseCode, studentEmail)] = groups;
  }

  @override
  Future<void> clearAllStudentGroupsCache() async {
    _studentGroupsByCourse.clear();
  }

  @override
  Future<void> clearGroupsByCourseCache(String courseCode) async {
    _groupsByCourse.remove(courseCode);
  }

  @override
  Future<void> clearStudentGroupsByCourseCache(
    String courseCode,
    String studentEmail,
  ) async {
    _studentGroupsByCourse.remove(_studentKey(courseCode, studentEmail));
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedGroupsByCourse(
    String courseCode,
  ) async {
    return _groupsByCourse[courseCode] ?? [];
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
  ) async {
    return _studentGroupsByCourse[_studentKey(courseCode, studentEmail)] ?? [];
  }

  @override
  Future<bool> isGroupsByCourseCacheValid(String courseCode) async => false;

  @override
  Future<bool> isStudentGroupsByCourseCacheValid(
    String courseCode,
    String studentEmail,
  ) async => false;
}

void main() {
  late FakeDio fakeDio;
  late AuthenticationController authController;
  late GroupsController groupsController;

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

    final source = GroupsSourceService(
      dio: fakeDio,
      databaseBaseUrl: 'https://test.com/database/test',
      authController: authController,
    );

    final cacheSource = FakeGroupsCacheSource();

    groupsController = GroupsController(
      repository: GroupsRepository(source: source, cacheSource: cacheSource),
    );

    Get.put<AuthenticationController>(authController);
  });

  tearDown(() {
    Get.reset();
  });

  test('LoadGroupsByCourse - success', () async {
    await groupsController.loadGroupsByCourse(
      courseCode: 'course1',
      accessToken: 'fake_token',
    );

    expect(groupsController.groups.length, 1);
    expect(groupsController.groups[0].groupCode, 'group1');
    expect(groupsController.errorMessage.value, '');
  });

  test('LoadGroupsByCourse - error', () async {
    fakeDio.shouldThrow = true;

    await groupsController.loadGroupsByCourse(
      courseCode: 'course1',
      accessToken: 'fake_token',
    );

    expect(groupsController.errorMessage.value, isNotEmpty);
  });
}
