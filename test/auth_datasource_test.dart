import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_application_1/controllers/authentication_controller.dart';
import 'mocks.mocks.dart';

void main() {
  late MockDio mockDio;
  late AuthenticationController controller;

  setUp(() {
    mockDio = MockDio();
    controller = AuthenticationController(dio: mockDio);
  });

  test('getStudentGroupsWithPeers returns list of groups', () async {
    final url = '${controller.databaseBaseUrl}/read';

    when(mockDio.get(url)).thenAnswer(
      (_) async => dio.Response(
        data: [
          {'GroupName': 'Grupo 1'},
          {'GroupName': 'Grupo 2'},
        ],
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: url),
      ),
    );

    final result = await controller.getStudentGroupsWithPeers();

    expect(result, isA<List<Map<String, dynamic>>>());
    expect(result.length, 2);
    expect(result[0]['GroupName'], 'Grupo 1');
    expect(result[1]['GroupName'], 'Grupo 2');

    verify(mockDio.get(url)).called(1);
  });

  test('getStudentGroupsWithPeers handles empty response', () async {
    final url = '${controller.databaseBaseUrl}/read';

    when(mockDio.get(url)).thenAnswer(
      (_) async => dio.Response(
        data: [],
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: url),
      ),
    );

    final result = await controller.getStudentGroupsWithPeers();

    expect(result, isEmpty);
    verify(mockDio.get(url)).called(1);
  });

  test('getStudentGroupsWithPeers throws on error', () async {
    final url = '${controller.databaseBaseUrl}/read';

    when(mockDio.get(url)).thenThrow(dio.DioException(
      requestOptions: dio.RequestOptions(path: url),
      error: 'Network error',
    ));

    expect(() => controller.getStudentGroupsWithPeers(), throwsA(isA<dio.DioException>()));
    verify(mockDio.get(url)).called(1);
  });
}