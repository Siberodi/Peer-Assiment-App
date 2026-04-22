import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/auth/data/models/app_user.dart';
import 'package:peer_assiment_app_1/features/assessments/domain/models/assessment.dart';
import 'package:peer_assiment_app_1/features/assessments/domain/repositories/i_assessments_repository.dart';
import 'package:peer_assiment_app_1/features/assessments/ui/viewmodels/assessments_controller.dart';
import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/groups/domain/models/group.dart';
import 'package:peer_assiment_app_1/features/groups/domain/models/group_member.dart';
import 'package:peer_assiment_app_1/features/groups/domain/repositories/i_groups_repository.dart';
import 'package:peer_assiment_app_1/features/groups/ui/pages/teacher_course_groups_page.dart';
import 'package:peer_assiment_app_1/features/groups/ui/viewmodels/groups_controller.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class MockAuthenticationController extends AuthenticationController with Mock {
  @override
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  @override
  String? get accessToken => 'mock_token';

  @override
  String get databaseBaseUrl => 'http://mockapi.com';
}

class FakeGroupsRepository implements IGroupsRepository {
  @override
  Future<List<Group>> getGroupsByCourse(
    String courseCode,
    String accessToken, {
    bool forceRefresh = false,
  }) async => [];

  @override
  Future<List<GroupMember>> getStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    String accessToken, {
    bool forceRefresh = false,
  }) async => [];

  @override
  Future<List<GroupMember>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  ) async => [];
}

class FakeAssessmentsRepository implements IAssessmentsRepository {
  @override
  Future<void> createAssessment({
    required String accessToken,
    required String assessmentName,
    required String courseCode,
    required String courseName,
    required String teacherEmail,
    required bool visibility,
    required String startAt,
    required String endAt,
    required bool status,
  }) async {}

  @override
  Future<List<Map<String, dynamic>>> getAssessmentResponses({
    required String accessToken,
    required String assessmentId,
  }) async => [];

  @override
  Future<List<Map<String, dynamic>>> getGroupMembers({
    required String accessToken,
    required String groupCode,
  }) async => [];

  @override
  Future<bool> hasStudentSubmittedAssessment({
    required String accessToken,
    required String assessmentId,
    required String evaluatorEmail,
  }) async => false;

  @override
  Future<void> publishAssessmentResults({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {}

  @override
  Future<void> replaceAssessmentResults({
    required String accessToken,
    required String assessmentId,
    required List<Map<String, dynamic>> records,
  }) async {}

  @override
  Future<void> submitAssessmentResponses({
    required String accessToken,
    required List<Map<String, dynamic>> records,
  }) async {}

  @override
  Future<List<Assessment>> getStudentAssessments({
    required String accessToken,
    required String courseCode,
    required String groupCode,
  }) async => [];

  @override
  Future<List<Assessment>> getTeacherAssessments({
    required String accessToken,
    required String teacherEmail,
  }) async => [];
}

void main() {
  late MockAuthenticationController controller;

  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    Get.reset();
    Get.testMode = true;

    controller = MockAuthenticationController();

    controller.currentUser.value = AppUser(
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    Get.put<AuthenticationController>(controller);
    Get.put<GroupsController>(
      GroupsController(repository: FakeGroupsRepository()),
      tag: 'teacher_groups_TEST101',
    );
    Get.put<AssessmentsController>(
      AssessmentsController(repository: FakeAssessmentsRepository()),
      tag: 'course_assessments_TEST101',
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'TeacherCourseGroupsPage muestra nombre del curso en AppBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Curso Test'), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCourseGroupsPage muestra loading inicialmente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCourseGroupsPage muestra botón crear evaluación',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text('Crear evaluación para este curso'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'TeacherCourseGroupsPage muestra sección evaluaciones',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Evaluaciones'), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCourseGroupsPage muestra mensaje sin grupos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Grupos'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No hay grupos en este curso'), findsOneWidget);
    },
  );
}
