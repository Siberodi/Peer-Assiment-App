import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/models/app_user.dart';
import 'package:app/core/app_role.dart';
import 'package:app/features/groups/ui/pages/teacher_course_groups_page.dart';

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
    'TeacherCourseGroupsPage muestra nombre del curso en AppBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Curso Test'), findsOneWidget);
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
        const MaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining('Crear evaluación para este curso'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'TeacherCourseGroupsPage muestra sección evaluaciones',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Evaluaciones del curso'), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCourseGroupsPage muestra mensaje sin grupos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('No hay grupos'), findsWidgets);
    },
  );
}