import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/auth/data/models/app_user.dart';
import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/groups/domain/models/group.dart';
import 'package:peer_assiment_app_1/features/groups/domain/models/group_member.dart';
import 'package:peer_assiment_app_1/features/groups/domain/repositories/i_groups_repository.dart';
import 'package:peer_assiment_app_1/features/groups/ui/pages/student_course_groups_page.dart';
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
    Get.put<GroupsController>(
      GroupsController(repository: FakeGroupsRepository()),
      tag: 'student_groups_TEST101',
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'StudentCourseGroupsPage muestra nombre del curso en AppBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudentCourseGroupsPage(
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
    'StudentCourseGroupsPage muestra loading inicialmente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const StudentCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'StudentCourseGroupsPage renderiza estructura básica',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudentCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
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
    'StudentCourseGroupsPage muestra mensaje sin grupos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudentCourseGroupsPage(
            courseCode: 'TEST101',
            courseName: 'Curso Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.text('No perteneces a grupos en este curso'),
        findsOneWidget,
      );
    },
  );
}
