import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:app/auth/verify_email.dart';
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

  testWidgets('VerifyEmailScreen muestra el campo de código y botón de verificación', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VerifyEmailScreen(
      email: 'test@test.com',
      password: 'password123',
      name: 'Test User',
      role: AppRole.student,
    )));

    expect(find.byKey(const Key('codeField')), findsOneWidget);
    expect(find.byKey(const Key('verifyButton')), findsOneWidget);
  });

  testWidgets('VerifyEmailScreen muestra error si el código es incorrecto', (WidgetTester tester) async {
    when(mockController.verifyEmailAndCompleteProfile(
      'test@test.com', 
      'password123', 
      'Test User', 
      AppRole.student, 
      'incorrectCode'
    )).thenThrow(Exception('Código incorrecto'));

    await tester.pumpWidget(const MaterialApp(home: VerifyEmailScreen(
      email: 'test@test.com',
      password: 'password123',
      name: 'Test User',
      role: AppRole.student,
    )));

    await tester.enterText(find.byKey(const Key('codeField')), 'incorrectCode');
    await tester.tap(find.byKey(const Key('verifyButton')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Error'), findsOneWidget);
  });

  testWidgets('VerifyEmailScreen realiza la verificación con éxito', (WidgetTester tester) async {
    when(mockController.verifyEmailAndCompleteProfile(
      'test@test.com', 
      'password123', 
      'Test User', 
      AppRole.student, 
      'correctCode'
    )).thenAnswer((_) async {
      mockController.currentUser.value = AppUser(
        email: 'test@test.com',
        name: 'Test User',
        role: AppRole.student,
      );
    });

    await tester.pumpWidget(const MaterialApp(home: VerifyEmailScreen(
      email: 'test@test.com',
      password: 'password123',
      name: 'Test User',
      role: AppRole.student,
    )));

    await tester.enterText(find.byKey(const Key('codeField')), 'correctCode');
    await tester.tap(find.byKey(const Key('verifyButton')));
    await tester.pumpAndSettle();

    expect(mockController.currentUser.value?.email, 'test@test.com');
  });
}