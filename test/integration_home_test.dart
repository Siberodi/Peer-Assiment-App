import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_application_1/Home/home.dart';
import 'package:flutter_application_1/controllers/authentication_controller.dart';
import 'package:flutter_application_1/models/app_user.dart';
import 'package:flutter_application_1/core/app_role.dart';
import '../test/mocks.mocks.dart';

void main() {
  late MockDio mockDio;
  late AuthenticationController controller;

  setUp(() {
    mockDio = MockDio();
    controller = AuthenticationController(dio: mockDio);

    controller.currentUser.value = AppUser(
      email: 'student@test.com',
      name: 'Test User',
      role: AppRole.student,
    );

    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Home integrado usa controller real y cliente HTTP mock', (WidgetTester tester) async {
    final url = '${controller.databaseBaseUrl}/read';

    when(mockDio.get(url)).thenAnswer(
      (_) async => dio.Response(
        data: [
          {'GroupName': 'Grupo Test'},
        ],
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: url),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Test User'), findsOneWidget);
    expect(find.text('Grupo Test'), findsOneWidget);
  });
}