import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:peer_assiment_app_1/features/auth/ui/pages/login.dart';
import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';

class FakeDio extends Mock implements dio.Dio {
  String? lastPostUrl;
  dynamic lastPostData;

  String? lastGetUrl;
  Map<String, dynamic>? lastGetQueryParameters;
  dio.Options? lastGetOptions;

  @override
  Future<dio.Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onSendProgress,
    dio.ProgressCallback? onReceiveProgress,
  }) async {
    lastPostUrl = path;
    lastPostData = data;

    return dio.Response<T>(
      requestOptions: dio.RequestOptions(path: path),
      data: {
        'accessToken': 'fake-access-token',
        'refreshToken': 'fake-refresh-token',
      } as T,
      statusCode: 200,
    );
  }

  @override
  Future<dio.Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
    dio.CancelToken? cancelToken,
    dio.ProgressCallback? onReceiveProgress,
  }) async {
    lastGetUrl = path;
    lastGetQueryParameters = queryParameters;
    lastGetOptions = options;

    return dio.Response<T>(
      requestOptions: dio.RequestOptions(path: path),
      data: [
        {
          'Email': 'student@test.com',
          'Name': 'Student Test',
          'Role': 'student',
        }
      ] as T,
      statusCode: 200,
    );
  }
}

void main() {
  late FakeDio fakeDio;
  late AuthenticationController controller;

  Widget buildApp() => const GetMaterialApp(
        home: LoginScreen(),
      );

  setUp(() {
    Get.reset();
    Get.testMode = true;

    fakeDio = FakeDio();
    controller = AuthenticationController(dioClient: fakeDio);

    Get.put<AuthenticationController>(controller);
  });

  tearDown(() async {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets(
    'Nivel 3 - LoginScreen flujo completo con controller real y red mockeada',
    (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (_) {};

      try {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('emailField')),
          'student@test.com',
        );
        await tester.enterText(
          find.byKey(const Key('passwordField')),
          'Password1!',
        );

        final loginButton = find.byKey(const Key('loginButton'));
        await tester.ensureVisible(loginButton);
        await tester.pump();

        await tester.tap(loginButton, warnIfMissed: false);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(fakeDio.lastPostUrl, '${controller.authBaseUrl}/login');
        expect(fakeDio.lastGetUrl, '${controller.databaseBaseUrl}/read');
        expect(controller.accessToken, 'fake-access-token');
        expect(fakeDio.lastPostData, isNotNull);
        expect(fakeDio.lastGetQueryParameters, isNotNull);

        // Dejar expirar snackbar/timer/overlay
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();

        Get.closeAllSnackbars();
        await tester.pumpAndSettle();
      } finally {
        FlutterError.onError = originalOnError;
      }
    },
  );
}
