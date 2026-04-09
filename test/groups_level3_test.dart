import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart' as dio;

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/core/app_role.dart';
import 'package:app/models/app_user.dart';
import 'package:app/features/groups/ui/viewmodels/groups_controller.dart';
import 'package:app/features/groups/data/repositories/groups_repository.dart';
import 'package:app/features/groups/data/datasources/remote/groups_source_service.dart';

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

void main() {
  late FakeDio fakeDio;
  late AuthenticationController authController;
  late GroupsController groupsController;

  setUp(() {
    Get.reset();
    Get.testMode = false;

    fakeDio = FakeDio();

    authController = AuthenticationController(dio: fakeDio);
    authController.currentUser.value = AppUser(
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    final source = GroupsSourceService(
      dio: fakeDio,
      databaseBaseUrl: 'https://test.com/database/test',
    );

    final repository = GroupsRepository(source: source);

    groupsController = GroupsController(repository: repository);

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