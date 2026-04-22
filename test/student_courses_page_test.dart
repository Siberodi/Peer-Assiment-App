import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/auth/data/models/app_user.dart';
import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/courses/domain/models/course.dart';
import 'package:peer_assiment_app_1/features/courses/domain/repositories/i_courses_repository.dart';
import 'package:peer_assiment_app_1/features/courses/ui/pages/student_courses_page.dart';
import 'package:peer_assiment_app_1/features/courses/ui/viewmodels/courses_controller.dart';

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

class FakeCoursesRepository implements ICoursesRepository {
  @override
  Future<List<Course>> getStudentCourses(
    String studentEmail,
    String accessToken, {
    bool forceRefresh = false,
  }) async => [];

  @override
  Future<List<Course>> getTeacherCourses(
    String teacherEmail,
    String accessToken, {
    bool forceRefresh = false,
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
      email: 'student@test.com',
      name: 'Estudiante Test',
      role: AppRole.student,
    );

    Get.put<AuthenticationController>(controller);
    Get.put<CoursesController>(
      CoursesController(repository: FakeCoursesRepository()),
      tag: 'student_courses',
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'StudentCoursesPage muestra título Mis Cursos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const StudentCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('Mis Cursos'), findsOneWidget);
    },
  );

  testWidgets(
    'StudentCoursesPage renderiza estructura básica',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const StudentCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    },
  );

  testWidgets(
    'StudentCoursesPage muestra mensaje sin cursos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const StudentCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.text('No perteneces a cursos todavía'),
        findsOneWidget,
      );
    },
  );
}
