import 'package:dio/dio.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/remote/i_groups_source.dart';

class GroupsSourceService implements IGroupsSource {
  final Dio dio;
  final String databaseBaseUrl;
  final AuthenticationController authController;

  bool get _isMockApi => databaseBaseUrl.contains('mockapi.com');

  GroupsSourceService({
    required this.dio,
    required this.databaseBaseUrl,
    required this.authController,
  });

  Future<Response<dynamic>> _authorizedGet(
    String path, {
    required String accessToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await authController.refreshAccessToken();

        if (!refreshed) {
          await authController.signOut();
          throw Exception('Sesión expirada. Inicia sesión nuevamente.');
        }

        final newToken = authController.accessToken;

        if (newToken == null || newToken.isEmpty) {
          throw Exception('No se pudo obtener un nuevo token');
        }

        return await dio.get(
          path,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              'Authorization': 'Bearer $newToken',
            },
          ),
        );
      }

      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGroupsByCourse(
    String courseCode,
    String accessToken,
  ) async {
    if (_isMockApi) {
      return [];
    }

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'Groups',
        'CourseCode': courseCode,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  ) async {
    if (_isMockApi) {
      return [];
    }

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'GroupMembers',
        'GroupCode': groupCode,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getStudentGroupsByCourse(
    String courseCode,
    String studentEmail,
    String accessToken,
  ) async {
    if (_isMockApi) {
      return [];
    }

    final response = await _authorizedGet(
      '$databaseBaseUrl/read',
      accessToken: accessToken,
      queryParameters: {
        'tableName': 'GroupMembers',
        'CourseCode': courseCode,
        'StudentEmail': studentEmail,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}