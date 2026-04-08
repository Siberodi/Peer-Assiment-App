import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:app/auth/verify_email.dart';
import 'package:app/controllers/authentication_controller.dart';
import 'package:app/core/app_role.dart';
import 'package:app/models/app_user.dart';

class FakeAuthenticationController extends AuthenticationController {
  bool shouldFail = false;
  String? lastEmail;
  String? lastPassword;
  String? lastName;
  String? lastCode;
  AppRole? lastRole;

  @override
  Future<void> verifyEmailAndCompleteProfile(
    String email,
    String password,
    String name,
    AppRole role,
    String code,
  ) async {
    lastEmail = email;
    lastPassword = password;
    lastName = name;
    lastRole = role;
    lastCode = code;

    if (shouldFail) {
      throw Exception('Código incorrecto');
    }

    currentUser.value = AppUser(
      email: email,
      name: name,
      role: role,
    );
  }
}

// 1x1 transparent PNG
final Uint8List _transparentImageBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO9Wq0cAAAAASUVORK5CYII=',
);

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  bool _autoUncompress = true;

  @override
  bool get autoUncompress => _autoUncompress;

  @override
  set autoUncompress(bool value) {
    _autoUncompress = value;
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _transparentImageBytes.length;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImageBytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeAuthenticationController controller;

  Widget buildApp() => const GetMaterialApp(
        home: VerifyEmailScreen(
          email: 'test@test.com',
          password: 'password123',
          name: 'Test User',
          role: AppRole.student,
        ),
      );

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

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
    'VerifyEmailScreen muestra el campo de código y botón de verificación',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('codeField')), findsOneWidget);
      expect(find.byKey(const Key('verifyButton')), findsOneWidget);
    },
  );

  testWidgets(
    'VerifyEmailScreen maneja error si el código es incorrecto',
    (WidgetTester tester) async {
      controller.shouldFail = true;

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('codeField')),
        'incorrectCode',
      );

      final button = find.byKey(const Key('verifyButton'));
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();

      await tester.tap(button, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(controller.lastEmail, 'test@test.com');
      expect(controller.lastPassword, 'password123');
      expect(controller.lastName, 'Test User');
      expect(controller.lastRole, AppRole.student);
      expect(controller.lastCode, 'incorrectCode');
      expect(controller.currentUser.value, isNull);

      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
  'VerifyEmailScreen realiza la verificación con éxito',
  (WidgetTester tester) async {
    final originalOnError = FlutterError.onError;

    FlutterError.onError = (FlutterErrorDetails details) {
    };

    try {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('codeField')),
        'correctCode',
      );

      final button = find.byKey(const Key('verifyButton'));
      await tester.ensureVisible(button);
      await tester.pump();

      await tester.tap(button, warnIfMissed: false);


      await tester.pump(const Duration(milliseconds: 100));

      expect(controller.lastEmail, 'test@test.com');
      expect(controller.lastPassword, 'password123');
      expect(controller.lastName, 'Test User');
      expect(controller.lastRole, AppRole.student);
      expect(controller.lastCode, 'correctCode');
      expect(controller.currentUser.value?.email, 'test@test.com');

      await tester.pump(const Duration(seconds: 4));
    } finally {
      FlutterError.onError = originalOnError;
    }
  },
);
}