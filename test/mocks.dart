import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/controllers/authentication_controller.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationController>(),
])
void main() {}