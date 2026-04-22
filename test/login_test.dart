import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:peer_assiment_app_1/features/auth/ui/pages/login.dart';
import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/auth/data/models/app_user.dart';

class MockAuthenticationController extends AuthenticationController with Mock {
  @override
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  @override
  Future<void> signIn(String email, String password) {
    return super.noSuchMethod(
      Invocation.method(#signIn, [email, password]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

void main() {
  late MockAuthenticationController controller;

  Widget buildApp() => const GetMaterialApp(home: LoginScreen());

  setUp(() {
    Get.reset();
    Get.testMode = true;

    controller = MockAuthenticationController();

    when(controller.signIn('student@test.com', 'password123'))
        .thenAnswer((_) async {});

    Get.put<AuthenticationController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'LoginScreen — Pruebas de Widget (Nivel 1) muestra el título Bienvenido',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Bienvenido'), findsOneWidget);
    },
  );

  testWidgets(
    'LoginScreen — Pruebas de Widget (Nivel 1) muestra el subtítulo Inicio de Sesión',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Inicio de Sesión'), findsWidgets);
    },
  );

  testWidgets(
    'LoginScreen — Pruebas de Widget (Nivel 1) tiene campos y botón',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(ElevatedButton), findsWidgets);
    },
  );

  testWidgets(
    'LoginScreen — Pruebas de Widget (Nivel 1) llama a signIn',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'student@test.com');
      await tester.enterText(fields.at(1), 'password123');
      await tester.pump();

      final loginButton = find.byKey(const Key('loginButton'));
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton, warnIfMissed: false);
      await tester.pump();

      verify(controller.signIn('student@test.com', 'password123')).called(1);
    },
  );
}
