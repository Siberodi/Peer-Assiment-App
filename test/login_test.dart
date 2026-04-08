import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/auth/login.dart';
import 'package:app/controllers/authentication_controller.dart';
import 'package:app/models/app_user.dart';
import 'package:app/core/app_role.dart';

class FakeAuthenticationController extends AuthenticationController {
  String? lastEmail;
  String? lastPassword;

  @override
  Future<void> signIn(String email, String password) async {
    lastEmail = email;
    lastPassword = password;

    currentUser.value = AppUser(
      email: email,
      name: 'Estudiante Test',
      role: AppRole.student,
    );
  }
}

void main() {
  late FakeAuthenticationController controller;

  Widget buildApp() => const MaterialApp(home: LoginScreen());

  setUp(() {
    Get.reset();
    Get.testMode = true;
    controller = FakeAuthenticationController();
    Get.put<AuthenticationController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('LoginScreen — Pruebas de Widget (Nivel 1) muestra el título Bienvenido',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Bienvenido'), findsOneWidget);
  });

  testWidgets('LoginScreen — Pruebas de Widget (Nivel 1) muestra el subtítulo Inicio de Sesión',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Inicio de Sesión'), findsWidgets);
  });

  testWidgets('LoginScreen — Pruebas de Widget (Nivel 1) tiene campo de correo, contraseña y botón',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets(
  'LoginScreen — Pruebas de Widget (Nivel 1) llama a signIn con credenciales válidas',
  (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'student@test.com');
    await tester.enterText(fields.at(1), 'password123');
    await tester.pump();

    final loginButton = find.byKey(const Key('loginButton'));

    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();

    await tester.tap(loginButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(controller.lastEmail, equals('student@test.com'));
    expect(controller.lastPassword, equals('password123'));
  },
);

  testWidgets('LoginScreen — Pruebas de Widget (Nivel 1) llama a signIn con credenciales válidas',
    (WidgetTester tester) async {

  await tester.pumpWidget(buildApp());
  await tester.pumpAndSettle();

  final fields = find.byType(TextFormField);

  await tester.enterText(fields.at(0), 'student@test.com');
  await tester.enterText(fields.at(1), 'password123');

  
  await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('loginButton')));
  await tester.pumpAndSettle();

  expect(controller.lastEmail, 'student@test.com');
  expect(controller.lastPassword, 'password123');
});
}