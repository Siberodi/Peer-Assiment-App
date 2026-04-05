import 'package:dio/dio.dart';
import 'i_groups_source.dart';

class GroupsSourceService implements IGroupsSource {
  final Dio dio;
  final String databaseBaseUrl;

  GroupsSourceService({
    required this.dio,
    required this.databaseBaseUrl,
  });

  @override
  Future<List<Map<String, dynamic>>> getGroupsByCourse(
    String courseCode,
    String accessToken,
  ) async {
    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'Groups',
        'CourseCode': courseCode,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getStudentsByGroup(
    String groupCode,
    String accessToken,
  ) async {
    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'GroupMembers',
        'GroupCode': groupCode,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
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
    final response = await dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'GroupMembers',
        'CourseCode': courseCode,
        'StudentEmail': studentEmail,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}