import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart' as dio;

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/core/app_role.dart';
import 'package:app/models/app_user.dart';
import 'package:app/features/courses/ui/viewmodels/courses_controller.dart';
import 'package:app/features/courses/data/repositories/courses_repository.dart';
import 'package:app/features/courses/data/datasources/remote/courses_source_service.dart';

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

void main() {
  late FakeDio fakeDio;
  late AuthenticationController authController;
  late CoursesController coursesController;

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

    final source = CoursesSourceService(
      dio: fakeDio,
      databaseBaseUrl: 'https://test.com/database/test',
    );

    final repository = CoursesRepository(source: source);

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