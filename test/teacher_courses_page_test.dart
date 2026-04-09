import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/models/app_user.dart';
import 'package:app/core/app_role.dart';
import 'package:app/features/courses/ui/pages/teacher_courses_page.dart';

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
    'TeacherCoursesPage muestra título Mis Cursos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Mis Cursos'), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCoursesPage renderiza estructura básica',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCoursesPage muestra mensaje sin cursos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.textContaining('No tienes cursos registrados'),
        findsWidgets,
      );
    },
  );
}