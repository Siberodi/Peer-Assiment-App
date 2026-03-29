import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:app/auth/login.dart';
import 'package:app/controllers/authentication_controller.dart';
import 'package:app/core/app_role.dart';

class MockAuthenticationController extends Mock implements AuthenticationController {}

void main() {
  late MockAuthenticationController mockController;

  setUp(() {
    mockController = MockAuthenticationController();
    Get.testMode = true;
    Get.put<AuthenticationController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildApp() => const MaterialApp(home: LoginScreen());

  group('LoginScreen — Pruebas de Widget (Nivel 1)', () {
    testWidgets('muestra el título Bienvenido', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Bienvenido'), findsOneWidget);
    });

    testWidgets('muestra el subtítulo Inicio de Sesión', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Inicio de Sesión'), findsOneWidget);
    });

    testWidgets('tiene campo de correo, contraseña y botón', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byKey(const Key('emailField')), findsOneWidget);
      expect(find.byKey(const Key('passwordField')), findsOneWidget);
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
    });

    testWidgets('llama a signIn con credenciales válidas', (WidgetTester tester) async {
      when(mockController.signIn('student@test.com', 'password123'))
          .thenAnswer((_) async {
        mockController.currentUser.value = AppUser(
          email: 'student@test.com',
          name: 'Test User',
          role: AppRole.student,
        );
      });

      await tester.pumpWidget(buildApp());
      await tester.enterText(find.byKey(const Key('emailField')), 'student@test.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
      await tester.ensureVisible(find.byKey(const Key('loginButton')));
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      verify(mockController.signIn('student@test.com', 'password123')).called(1);
      expect(mockController.currentUser.value?.email, 'student@test.com');
    });
  });
}