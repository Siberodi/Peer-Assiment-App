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
import 'package:peer_assiment_app_1/features/courses/ui/pages/teacher_courses_page.dart';
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
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    Get.put<AuthenticationController>(controller);
    Get.put<CoursesController>(
      CoursesController(repository: FakeCoursesRepository()),
      tag: 'teacher_courses',
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'TeacherCoursesPage muestra título Mis Cursos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Mi cursos'), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCoursesPage renderiza estructura básica',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherCoursesPage muestra mensaje sin cursos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherCoursesPage(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text('No tienes cursos registrados todavía'),
        findsOneWidget,
      );
    },
  );
}
