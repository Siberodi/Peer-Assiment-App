import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/auth/register.dart';
import 'package:app/controllers/authentication_controller.dart';
import 'package:app/core/app_role.dart';
import 'package:app/models/app_user.dart';

class FakeAuthenticationController extends AuthenticationController {
  String? lastEmail;
  String? lastPassword;
  String? lastName;
  AppRole? lastRole;

  @override
  Future<void> signUp(
    String email,
    String password,
    String name,
    AppRole role,
  ) async {
    lastEmail = email;
    lastPassword = password;
    lastName = name;
    lastRole = role;

    currentUser.value = AppUser(
      email: email,
      name: name,
      role: role,
    );
  }
}

void main() {
  late FakeAuthenticationController controller;

  Widget buildApp() => const GetMaterialApp(
        home: RegisterScreen(),
      );

  setUp(() {
    Get.reset();
    Get.testMode = true;
    controller = FakeAuthenticationController();
    Get.put<AuthenticationController>(controller);
  });

  tearDown(() async {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets(
    'RegisterScreen muestra el título',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Regístrate'), findsOneWidget);
    },
  );

  testWidgets(
    'RegisterScreen llama a signUp correctamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('emailField')),
        'ana@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('nameField')),
        'Ana García',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'Secure1!',
      );
      await tester.pump();

      final firstCheckbox = find.byType(Checkbox).first;
      await tester.ensureVisible(firstCheckbox);
      await tester.pumpAndSettle();
      await tester.tap(firstCheckbox, warnIfMissed: false);
      await tester.pumpAndSettle();

      final button = find.byKey(const Key('registerButton'));
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(controller.lastEmail, 'ana@example.com');
      expect(controller.lastPassword, 'Secure1!');
      expect(controller.lastName, 'Ana García');
      expect(controller.lastRole, AppRole.student);
      expect(controller.currentUser.value?.email, 'ana@example.com');

      // Dejar que expire el timer del snackbar
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    },
  );
}