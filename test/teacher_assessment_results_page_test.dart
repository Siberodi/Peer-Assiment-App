import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:app/features/auth/data/models/app_user.dart';
import 'package:app/core/app_role.dart';
import 'package:app/features/assessments/ui/pages/teacher_assessment_results_page.dart';

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
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    Get.put<AuthenticationController>(controller);
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
      expect(find.byType(AppBar), findsOneWidget);
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