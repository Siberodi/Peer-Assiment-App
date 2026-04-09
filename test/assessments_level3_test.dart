import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart' as dio;

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/core/app_role.dart';
import 'package:app/models/app_user.dart';
import 'package:app/features/assessments/ui/viewmodels/assessments_controller.dart';
import 'package:app/features/assessments/data/repositories/assessments_repository.dart';
import 'package:app/features/assessments/data/datasources/remote/assessments_source_service.dart';

class FakeDio extends Mock implements dio.Dio {
  bool shouldThrow = false;

  @override
  Future<dio.Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
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
      data: {'inserted': [1], 'skipped': []} as T,
      statusCode: 200,
    );
  }

  @override
  Future<dio.Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onReceiveProgress,
  }) async {
    return dio.Response<T>(
      requestOptions: dio.RequestOptions(path: path),
      data: [
        {
          'AssessmentName': 'Test Assessment',
          'CourseCode': 'course1',
          'CourseName': 'Test Course',
          'TeacherEmail': 'teacher@test.com',
          'Visibility': true,
          'StartAt': '2024-01-01T00:00:00.000Z',
          'EndAt': '2024-01-02T00:00:00.000Z',
          'Status': true,
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
  late AssessmentsController assessmentsController;

  setUp(() {
    Get.reset();
    Get.testMode = true;

    fakeDio = FakeDio();

    authController = AuthenticationController(dio: fakeDio);
    authController.currentUser.value = AppUser(
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    final source = AssessmentsSourceService(
      dio: fakeDio,
      databaseBaseUrl: 'https://test.com/database/test',
    );

    final repository = AssessmentsRepository(source: source);

    assessmentsController = AssessmentsController(repository: repository);

    Get.put<AuthenticationController>(authController);
  });

  tearDown(() {
    Get.reset();
  });

  test('CreateAssessment - success', () async {
    await assessmentsController.createAssessment(
      accessToken: 'fake_token',
      assessmentName: 'Test Assessment',
      courseCode: 'course1',
      courseName: 'Test Course',
      teacherEmail: 'teacher@test.com',
      visibility: true,
      startAt: '2024-01-01T00:00:00.000Z',
      endAt: '2024-01-02T00:00:00.000Z',
      status: true,
    );

    expect(assessmentsController.errorMessage.value, '');
  });

  test('CreateAssessment - error', () async {
    fakeDio.shouldThrow = true;

    await assessmentsController.createAssessment(
      accessToken: 'fake_token',
      assessmentName: 'Test Assessment',
      courseCode: 'course1',
      courseName: 'Test Course',
      teacherEmail: 'teacher@test.com',
      visibility: true,
      startAt: '2024-01-01T00:00:00.000Z',
      endAt: '2024-01-02T00:00:00.000Z',
      status: true,
    );

    expect(assessmentsController.errorMessage.value, isNotEmpty);
  });
}