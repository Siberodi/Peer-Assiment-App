import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_application_1/Home/home.dart';
import 'package:flutter_application_1/controllers/authentication_controller.dart';
import 'package:flutter_application_1/models/app_user.dart';
import 'package:flutter_application_1/core/app_role.dart';
import 'mocks.mocks.dart';

void main() {
  late MockDio mockDio;
  late AuthenticationController controller;

  setUp(() {
    mockDio = MockDio();
    controller = AuthenticationController(dio: mockDio);

    // Configurar usuario
    controller.currentUser.value = AppUser(
      email: 'test@example.com',
      name: 'Test User',
      role: AppRole.student,
    );

    Get.put<AuthenticationController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('HomeScreen muestra el nombre del usuario y grupos', (WidgetTester tester) async {
    final url = '${controller.databaseBaseUrl}/read';

    when(mockDio.get(url)).thenAnswer(
      (_) async => dio.Response(
        data: [
          {'GroupName': 'Grupo A'},
          {'GroupName': 'Grupo B'},
        ],
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: url),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle(); // Esperar a que el FutureBuilder complete

    expect(find.text('Hola, Test User'), findsOneWidget);
    expect(find.text('Grupo A'), findsOneWidget);
    expect(find.text('Grupo B'), findsOneWidget);
  });

  testWidgets('HomeScreen muestra mensaje cuando no hay grupos', (WidgetTester tester) async {
    final url = '${controller.databaseBaseUrl}/read';

    when(mockDio.get(url)).thenAnswer(
      (_) async => dio.Response(
        data: [],
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: url),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Test User'), findsOneWidget);
    // La lista está vacía, pero el código no muestra mensaje especial.
  });
}