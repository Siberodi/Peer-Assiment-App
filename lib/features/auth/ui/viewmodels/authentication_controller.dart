import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/auth/data/models/app_user.dart';

class AuthenticationController extends GetxController {
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  late final dio.Dio _dio;

  AuthenticationController({dio.Dio? dioClient})
      : _dio = dioClient ?? dio.Dio();

  final String dbName = 'programacinmovil_project_3b5eaf6ff0';

  String get authBaseUrl =>
      'https://roble-api.openlab.uninorte.edu.co/auth/$dbName';

  String get databaseBaseUrl =>
      'https://roble-api.openlab.uninorte.edu.co/database/$dbName';

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  String _extractErrorMessage(
    dio.DioException e, {
    String fallback = 'Error de red',
  }) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    if (data is Map) {
      final message = data['message'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return e.message ?? fallback;
  }

  List<dynamic> _safeList(dynamic data) {
    if (data is List) return data;
    return [];
  }

  Map<String, dynamic> _safeMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  Future<bool> refreshAccessToken() async {
    try {
      if (_refreshToken == null || _refreshToken!.isEmpty) {
        return false;
      }

      final response = await _dio.post(
        '$authBaseUrl/refresh',
        data: {
          'refreshToken': _refreshToken,
        },
      );

      final responseData = _safeMap(response.data);

      final newAccessToken = responseData['accessToken']?.toString();
      final newRefreshToken =
          responseData['refreshToken']?.toString() ?? _refreshToken;

      if (newAccessToken == null || newAccessToken.isEmpty) {
        return false;
      }

      _accessToken = newAccessToken;
      _refreshToken = newRefreshToken;

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<dio.Response<dynamic>> _authorizedRequest(
    Future<dio.Response<dynamic>> Function(String token) request,
  ) async {
    if (_accessToken == null || _accessToken!.isEmpty) {
      throw Exception('Usuario no autenticado');
    }

    try {
      return await request(_accessToken!);
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final bool refreshed = await refreshAccessToken();

        if (!refreshed) {
          await signOut();
          throw Exception('Sesión expirada. Inicia sesión nuevamente.');
        }

        return await request(_accessToken!);
      }

      rethrow;
    }
  }

  Future<dio.Response<dynamic>> _authorizedGet(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _authorizedRequest(
      (token) => _dio.get(
        path,
        queryParameters: queryParameters,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ),
    );
  }

  Future<dio.Response<dynamic>> _authorizedPost(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _authorizedRequest(
      (token) => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ),
    );
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    AppRole role,
  ) async {
    try {
      await _dio.post(
        '$authBaseUrl/signup',
        data: {
          'email': email.trim(),
          'password': password,
          'name': name.trim(),
        },
      );
    } on dio.DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, fallback: 'Error en registro'),
      );
    } catch (e) {
      throw Exception('Error en registro: $e');
    }
  }

  Future<void> verifyEmailAndCompleteProfile(
    String email,
    String password,
    String name,
    AppRole role,
    String code,
  ) async {
    try {
      await _dio.post(
        '$authBaseUrl/verify-email',
        data: {
          'email': email.trim(),
          'code': code.trim(),
        },
      );

      final loginResponse = await _dio.post(
        '$authBaseUrl/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final loginData = _safeMap(loginResponse.data);

      final tempAccessToken = loginData['accessToken']?.toString();
      final tempRefreshToken = loginData['refreshToken']?.toString();

      if (tempAccessToken == null || tempAccessToken.isEmpty) {
        throw Exception('No se obtuvo accessToken');
      }

      final previousAccessToken = _accessToken;
      final previousRefreshToken = _refreshToken;

      _accessToken = tempAccessToken;
      _refreshToken = tempRefreshToken;

      try {
        final insertResponse = await _authorizedPost(
          '$databaseBaseUrl/insert',
          data: {
            'tableName': 'Users',
            'records': [
              {
                'Email': email.trim(),
                'Name': name.trim(),
                'Role': role.value,
              }
            ],
          },
        );

        final insertData = _safeMap(insertResponse.data);
        final inserted = _safeList(insertData['inserted']);
        final skipped = _safeList(insertData['skipped']);

        if (inserted.isEmpty && skipped.isNotEmpty) {
          throw Exception('No se pudo guardar el perfil del usuario');
        }

        currentUser.value = AppUser(
          email: email.trim(),
          name: name.trim(),
          role: role,
        );
      } catch (e) {
        _accessToken = previousAccessToken;
        _refreshToken = previousRefreshToken;
        rethrow;
      }
    } on dio.DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, fallback: 'Error al verificar correo'),
      );
    } catch (e) {
      throw Exception('Error al verificar correo: $e');
    }
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    try {
      final loginResponse = await _dio.post(
        '$authBaseUrl/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final loginData = _safeMap(loginResponse.data);

      _accessToken = loginData['accessToken']?.toString();
      _refreshToken = loginData['refreshToken']?.toString();

      if (_accessToken == null || _accessToken!.isEmpty) {
        throw Exception('No se obtuvo accessToken');
      }

      final readResponse = await _authorizedGet(
        '$databaseBaseUrl/read',
        queryParameters: {
          'tableName': 'Users',
          'Email': email.trim(),
        },
      );

      final List<dynamic> users = _safeList(readResponse.data);

      if (users.isEmpty) {
        throw Exception('No existe perfil para este usuario en la tabla Users');
      }

      final userData = _safeMap(users.first);
      final role = appRoleFromString(userData['Role']?.toString() ?? '');

      currentUser.value = AppUser(
        email: userData['Email']?.toString() ?? email.trim(),
        name: userData['Name']?.toString() ?? '',
        role: role,
      );
    } on dio.DioException catch (e) {
      throw Exception(
        'Error en login: ${_extractErrorMessage(e)}',
      );
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }

  Future<void> signOut() async {
    try {
      if (_accessToken != null && _accessToken!.isNotEmpty) {
        await _dio.post(
          '$authBaseUrl/logout',
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          ),
        );
      }
    } catch (_) {
      // Ignorar error remoto de logout
    } finally {
      _accessToken = null;
      _refreshToken = null;
      currentUser.value = null;
    }
  }

  Future<void> uploadCsvAndCreateGroups() async {
    try {
      if (_accessToken == null || _accessToken!.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result == null) return;

      final pickedFile = result.files.first;

      List<int>? fileBytes = pickedFile.bytes;

      if (fileBytes == null && pickedFile.path != null) {
        final file = File(pickedFile.path!);
        fileBytes = await file.readAsBytes();
      }

      if (fileBytes == null) {
        throw Exception('No se pudo leer el archivo');
      }

      final csvString = utf8.decode(fileBytes);

      final rows = const CsvToListConverter(
        shouldParseNumbers: false,
        eol: '\n',
      ).convert(csvString);

      if (rows.isEmpty) {
        throw Exception('El CSV está vacío');
      }

      final dataRows = rows.skip(1);
      final teacherEmail = currentUser.value?.email;

      if (teacherEmail == null || teacherEmail.trim().isEmpty) {
        throw Exception('No se encontró el docente autenticado');
      }

      final Set<String> createdCourses = {};
      final Set<String> createdGroups = {};
      final Set<String> createdCourseStudents = {};
      final Set<String> createdGroupMembers = {};

      for (final row in dataRows) {
        if (row.length < 8) continue;

        final groupName = row[1].toString().trim();
        final groupCode = row[2].toString().trim();
        final firstName = row[5].toString().trim();
        final lastName = row[6].toString().trim();
        final studentEmail = row[7].toString().trim();

        final parts = groupCode.split('_');
        final courseCode = parts.length >= 3 ? parts[2].trim() : '';

        if (courseCode.isEmpty ||
            groupName.isEmpty ||
            groupCode.isEmpty ||
            studentEmail.isEmpty) {
          continue;
        }

        final studentName = '$firstName $lastName'.trim();
        final courseName = 'Curso $courseCode';
        final now = DateTime.now().toIso8601String();

        if (!createdCourses.contains(courseCode)) {
          await _authorizedPost(
            '$databaseBaseUrl/insert',
            data: {
              'tableName': 'Courses',
              'records': [
                {
                  'CourseCode': courseCode,
                  'CourseName': courseName,
                  'TeacherEmail': teacherEmail,
                  'CreatedAt': now,
                }
              ],
            },
          );

          createdCourses.add(courseCode);
        }

        if (!createdGroups.contains(groupCode)) {
          await _authorizedPost(
            '$databaseBaseUrl/insert',
            data: {
              'tableName': 'Groups',
              'records': [
                {
                  'CourseCode': courseCode,
                  'GroupName': groupName,
                  'GroupCode': groupCode,
                  'TeacherEmail': teacherEmail,
                  'CreatedAt': now,
                }
              ],
            },
          );

          createdGroups.add(groupCode);
        }

        final courseStudentKey = '$courseCode|$studentEmail';

        if (!createdCourseStudents.contains(courseStudentKey)) {
          await _authorizedPost(
            '$databaseBaseUrl/insert',
            data: {
              'tableName': 'CourseStudents',
              'records': [
                {
                  'CourseCode': courseCode,
                  'StudentEmail': studentEmail,
                  'StudentName': studentName,
                  'TeacherEmail': teacherEmail,
                  'CreatedAt': now,
                }
              ],
            },
          );

          createdCourseStudents.add(courseStudentKey);
        }

        final groupMemberKey = '$groupCode|$studentEmail';

        if (!createdGroupMembers.contains(groupMemberKey)) {
          await _authorizedPost(
            '$databaseBaseUrl/insert',
            data: {
              'tableName': 'GroupMembers',
              'records': [
                {
                  'CourseCode': courseCode,
                  'GroupCode': groupCode,
                  'GroupName': groupName,
                  'StudentEmail': studentEmail,
                  'StudentName': studentName,
                  'TeacherEmail': teacherEmail,
                  'CreatedAt': now,
                }
              ],
            },
          );

          createdGroupMembers.add(groupMemberKey);
        }
      }
    } on dio.DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, fallback: 'Error subiendo CSV'),
      );
    } catch (e) {
      throw Exception('Error procesando CSV: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStudentGroupsWithPeers() async {
    try {
      if (_accessToken == null || _accessToken!.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      final studentEmail = currentUser.value?.email;

      if (studentEmail == null || studentEmail.trim().isEmpty) {
        throw Exception('No se encontró el correo del estudiante');
      }

      final response = await _authorizedGet(
        '$databaseBaseUrl/read',
        queryParameters: {
          'tableName': 'GroupMembers',
          'StudentEmail': studentEmail,
        },
      );

      final List<dynamic> myMemberships = _safeList(response.data);

      if (myMemberships.isEmpty) {
        return [];
      }

      final List<Map<String, dynamic>> result = [];

      for (final membership in myMemberships) {
        final membershipMap = _safeMap(membership);

        final groupCode = membershipMap['GroupCode']?.toString() ?? '';
        final groupName = membershipMap['GroupName']?.toString() ?? '';
        final courseCode = membershipMap['CourseCode']?.toString() ?? '';
        final teacherEmail = membershipMap['TeacherEmail']?.toString() ?? '';

        if (groupCode.isEmpty) continue;

        final peersResponse = await _authorizedGet(
          '$databaseBaseUrl/read',
          queryParameters: {
            'tableName': 'GroupMembers',
            'GroupCode': groupCode,
          },
        );

        final List<dynamic> allMembers = _safeList(peersResponse.data);

        final peers = allMembers
            .map((e) => _safeMap(e))
            .where(
              (member) =>
                  (member['StudentEmail']?.toString() ?? '')
                      .trim()
                      .toLowerCase() !=
                  studentEmail.trim().toLowerCase(),
            )
            .toList();

        result.add({
          'CourseCode': courseCode,
          'GroupCode': groupCode,
          'GroupName': groupName,
          'TeacherEmail': teacherEmail,
          'PeerCount': peers.length,
          'Peers': peers,
        });
      }

      return result;
    } on dio.DioException catch (e) {
      throw Exception(
        _extractErrorMessage(
          e,
          fallback: 'Error obteniendo grupos con compañeros',
        ),
      );
    } catch (e) {
      throw Exception('Error obteniendo grupos con compañeros: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStudentActiveAssessments() async {
    try {
      if (_accessToken == null || _accessToken!.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      final studentEmail = currentUser.value?.email;

      if (studentEmail == null || studentEmail.trim().isEmpty) {
        throw Exception('No se encontró el correo del estudiante');
      }

      final groups = await getStudentGroupsWithPeers();

      if (groups.isEmpty) {
        return [];
      }

      final List<Map<String, dynamic>> assessments = [];

      for (final group in groups) {
        final courseCode = group['CourseCode']?.toString() ?? '';

        if (courseCode.isEmpty) continue;

        final response = await _authorizedGet(
          '$databaseBaseUrl/read',
          queryParameters: {
            'tableName': 'Assessments',
            'CourseCode': courseCode,
            'Status': true,
          },
        );

        final List<dynamic> data = _safeList(response.data);

        for (final e in data) {
          final assessment = _safeMap(e);

          final now = DateTime.now();
          final start = DateTime.tryParse(
            assessment['StartAt']?.toString() ?? '',
          );
          final end = DateTime.tryParse(
            assessment['EndAt']?.toString() ?? '',
          );

          if (start != null && end != null) {
            if (now.isAfter(start) && now.isBefore(end)) {
              assessments.add(assessment);
            }
          }
        }
      }

      return assessments;
    } on dio.DioException catch (e) {
      throw Exception(
        _extractErrorMessage(
          e,
          fallback: 'Error obteniendo evaluaciones activas',
        ),
      );
    } catch (e) {
      throw Exception('Error obteniendo evaluaciones activas: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getStudentPublishedResults() async {
    try {
      if (_accessToken == null || _accessToken!.isEmpty) {
        throw Exception('Usuario no autenticado');
      }

      final studentEmail = currentUser.value?.email;

      if (studentEmail == null || studentEmail.trim().isEmpty) {
        throw Exception('No se encontró el correo del estudiante');
      }

      final response = await _authorizedGet(
        '$databaseBaseUrl/read',
        queryParameters: {
          'tableName': 'AssessmentResults',
          'StudentEmail': studentEmail,
          'Published': true,
        },
      );

      final List<dynamic> data = _safeList(response.data);

      return data.map((e) => _safeMap(e)).toList();
    } on dio.DioException catch (e) {
      throw Exception(
        _extractErrorMessage(
          e,
          fallback: 'Error obteniendo calificaciones publicadas',
        ),
      );
    } catch (e) {
      throw Exception('Error obteniendo calificaciones publicadas: $e');
    }
  }
}