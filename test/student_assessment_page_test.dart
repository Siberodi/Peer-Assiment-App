import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/models/app_user.dart';
import 'package:app/core/app_role.dart';
import 'package:app/features/assessments/ui/pages/student_assessment_page.dart';

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
      email: 'student@test.com',
      name: 'Estudiante Test',
      role: AppRole.student,
    );

    Get.put<AuthenticationController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'StudentAssessmentPage muestra título de evaluaciones',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudentAssessmentPage(
            assessmentId: 'test-id',
            groupCode: 'group1',
            courseCode: 'course1',
            assessmentName: 'Test Assessment',
            peers: [],
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Test Assessment'), findsOneWidget);
    },
  );

  testWidgets(
    'StudentAssessmentPage muestra lista o contenido',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudentAssessmentPage(
            assessmentId: 'test-id',
            groupCode: 'group1',
            courseCode: 'course1',
            assessmentName: 'Test Assessment',
            peers: [],
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(ListView), findsWidgets);
    },
  );

  testWidgets(
    'StudentAssessmentPage renderiza sin errores',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudentAssessmentPage(
            assessmentId: 'test-id',
            groupCode: 'group1',
            courseCode: 'course1',
            assessmentName: 'Test Assessment',
            peers: [],
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(Scaffold), findsOneWidget);
    },
  );
}