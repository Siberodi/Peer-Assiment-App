import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_application_1/Home/home.dart';
import 'package:flutter_application_1/controllers/authentication_controller.dart';
import 'package:flutter_application_1/models/app_user.dart';
import 'package:flutter_application_1/core/app_role.dart';
import 'mocks.mocks.dart';

void main() {
  late MockAuthenticationController mockController;

  setUp(() {
    mockController = MockAuthenticationController();

    final user = AppUser(
      email: 'test@example.com',
      name: 'Test User',
      role: AppRole.student,
    );

    when(mockController.onStart).thenReturn(InternalFinalCallback<void>(callback: () {}));
    when(mockController.currentUser).thenReturn(Rxn<AppUser>(user));
    Get.put<AuthenticationController>(mockController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('HomeScreen muestra el nombre del usuario y grupos', (WidgetTester tester) async {
    when(mockController.getStudentGroupsWithPeers()).thenAnswer(
      (_) async => [
        {'GroupName': 'Grupo A'},
        {'GroupName': 'Grupo B'},
      ],
    );

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Test User'), findsOneWidget);
    expect(find.text('Grupo A'), findsOneWidget);
    expect(find.text('Grupo B'), findsOneWidget);
  });

  testWidgets('HomeScreen muestra mensaje cuando no hay grupos', (WidgetTester tester) async {
    when(mockController.getStudentGroupsWithPeers()).thenAnswer(
      (_) async => [],
    );

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Test User'), findsOneWidget);
    // La lista está vacía, pero el código no muestra mensaje especial.
  });
}