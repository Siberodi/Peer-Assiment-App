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
import 'package:peer_assiment_app_1/features/assessments/ui/pages/teacher_assessment_results_page.dart';

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
  late AssessmentsController assessmentsController;

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
    assessmentsController = AssessmentsController(
      repository: FakeAssessmentsRepository(),
    );
    Get.put<AssessmentsController>(
      assessmentsController,
      tag: 'professor_home_assessments',
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'TeacherAssessmentResultsPage muestra el nombre de la evaluación en el AppBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TeacherAssessmentResultsPage(
            assessmentId: '1',
            assessmentName: 'Evaluación Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Evaluación Test'), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherAssessmentResultsPage renderiza estructura básica',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TeacherAssessmentResultsPage(
            assessmentId: '1',
            assessmentName: 'Evaluación Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.publish_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherAssessmentResultsPage muestra mensaje sin respuestas',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TeacherAssessmentResultsPage(
            assessmentId: '1',
            assessmentName: 'Evaluación Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('No hay respuestas todavía'), findsWidgets);
    },
  );
}
