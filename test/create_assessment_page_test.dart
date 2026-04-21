import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/models/app_user.dart';
import 'package:app/core/app_role.dart';
import 'package:app/features/assessments/ui/pages/create_assessment_page.dart';

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
  late MockAuthenticationController authController;

  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    Get.reset();
    Get.testMode = true;

    authController = MockAuthenticationController();

    authController.currentUser.value = AppUser(
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    Get.put<AuthenticationController>(authController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'CreateAssessmentPage muestra el título Crear Evaluación',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const CreateAssessmentPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Crear Evaluación'), findsOneWidget);
    },
  );

  testWidgets(
    'CreateAssessmentPage muestra campos principales',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const CreateAssessmentPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Fin'), findsOneWidget);
    },
  );

  testWidgets(
    'CreateAssessmentPage muestra switch de visibilidad',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const CreateAssessmentPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.textContaining('Visible'), findsOneWidget);
    },
  );

  testWidgets(
    'CreateAssessmentPage permite escribir nombre',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const CreateAssessmentPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.enterText(
        find.byType(TextField),
        'Evaluación Test',
      );

      expect(find.text('Evaluación Test'), findsOneWidget);
    },
  );

  testWidgets(
    'CreateAssessmentPage muestra botón Crear evaluación',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const CreateAssessmentPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Crear evaluación'), findsOneWidget);
    },
  );

}

