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
import 'package:peer_assiment_app_1/features/groups/ui/pages/teacher_group_members_page.dart';
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
      email: 'teacher@test.com',
      name: 'Profesor Test',
      role: AppRole.teacher,
    );

    Get.put<AuthenticationController>(controller);
    Get.put<GroupsController>(
      GroupsController(repository: FakeGroupsRepository()),
      tag: 'group_members_G1',
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'TeacherGroupMembersPage muestra nombre del grupo en AppBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherGroupMembersPage(
            groupCode: 'G1',
            groupName: 'Grupo Test',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Grupo Test'), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherGroupMembersPage muestra loading inicialmente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const TeacherGroupMembersPage(
            groupCode: 'G1',
            groupName: 'Grupo Test',
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherGroupMembersPage renderiza estructura básica',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherGroupMembersPage(
            groupCode: 'G1',
            groupName: 'Grupo Test',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'TeacherGroupMembersPage muestra mensaje sin estudiantes',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: TeacherGroupMembersPage(
            groupCode: 'G1',
            groupName: 'Grupo Test',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('No hay estudiantes en este grupo'),
        findsOneWidget,
      );
    },
  );
}
