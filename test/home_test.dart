import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/Home/home.dart';
import 'package:app/controllers/authentication_controller.dart';
import 'package:app/models/app_user.dart';
import 'package:app/core/app_role.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class FakeAuthenticationController extends AuthenticationController {
  FakeAuthenticationController({
    List<Map<String, dynamic>> groups = const [],
  }) : _groups = groups;

  final List<Map<String, dynamic>> _groups;

  @override
  Future<List<Map<String, dynamic>>> getStudentGroupsWithPeers() async {
    return _groups;
  }
}

void main() {
  late FakeAuthenticationController controller;

  setUpAll(() {
    HttpOverrides.global = MyHttpOverrides();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    Get.reset();
    Get.testMode = true;

    controller = FakeAuthenticationController(groups: []);

    controller.currentUser.value = AppUser(
      email: 'maria@test.com',
      name: 'María López',
      role: AppRole.student,
    );

    Get.put<AuthenticationController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('HomeScreen muestra el texto de error cuando no hay grupos',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(
      find.textContaining('No perteneces a ningún grupo'),
      findsOneWidget,
    );
  });

  testWidgets('HomeScreen muestra el nombre del usuario en el AppBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.textContaining('María López'), findsOneWidget);
  });
}