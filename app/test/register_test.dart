import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:app/auth/register.dart';
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

  Widget buildApp() => const MaterialApp(home: RegisterScreen());

  group('RegisterScreen — Pruebas de Widget (Nivel 1)', () {
    testWidgets('muestra el título Crear Cuenta', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Crear Cuenta'), findsOneWidget);
    });

    testWidgets('llama a signUp con datos correctos para estudiante', (WidgetTester tester) async {
      when(mockController.signUp('ana@example.com', 'securePass1', 'Ana García', AppRole.student))
          .thenAnswer((_) async {
        mockController.currentUser.value = AppUser(
          email: 'ana@example.com',
          name: 'Ana García',
          role: AppRole.student,
        );
      });

      await tester.pumpWidget(buildApp());
      await tester.enterText(find.byKey(const Key('nameField')), 'Ana García');
      await tester.enterText(find.byKey(const Key('emailField')), 'ana@example.com');
      await tester.enterText(find.byKey(const Key('passwordField')), 'securePass1');
      await tester.tap(find.byKey(const Key('studentRadio')));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const Key('registerButton')));
      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pump();

      verify(mockController.signUp('ana@example.com', 'securePass1', 'Ana García', AppRole.student)).called(1);
      expect(mockController.currentUser.value?.email, 'ana@example.com');
    });
  });
}