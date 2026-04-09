import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:app/controllers/authentication_controller.dart';
import 'package:app/models/app_user.dart';
import 'package:app/core/app_role.dart';
import 'package:app/features/groups/ui/pages/teacher_group_members_page.dart';

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
    'TeacherGroupMembersPage muestra nombre del grupo en AppBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherGroupMembersPage(
            groupCode: 'G1',
            groupName: 'Grupo Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

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
        const MaterialApp(
          home: TeacherGroupMembersPage(
            groupCode: 'G1',
            groupName: 'Grupo Test',
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
    'TeacherGroupMembersPage muestra mensaje sin estudiantes',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherGroupMembersPage(
            groupCode: 'G1',
            groupName: 'Grupo Test',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(
        find.textContaining('No hay estudiantes'),
        findsWidgets,
      );
    },
  );
}