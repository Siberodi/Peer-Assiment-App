import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../core/app_role.dart';
import '../models/app_user.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class AuthenticationController extends GetxController {
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  final Dio _dio = Dio();

  final String dbName = 'programacinmovil_project_3b5eaf6ff0';

  String get authBaseUrl =>
      'https://roble-api.openlab.uninorte.edu.co/auth/$dbName';

  String get databaseBaseUrl =>
      'https://roble-api.openlab.uninorte.edu.co/database/$dbName';

  String? _accessToken;
  String? _refreshToken;

  Future<void> signUp(
  String email,
  String password,
  String name,
  AppRole role,
) async {
        try {
          print('AUTH signup -> inicio');
          final response = await _dio.post( 
            '$authBaseUrl/signup',
            data: {
              'email': email.trim(),
              'password': password,
              'name': name.trim(),
            },
          );
          print('AUTH signup -> ok: ${response.data}'); // para probar
        } on DioException catch (e) {
          throw Exception(
            e.response?.data['message'] ?? 'Error en registro',
          );
        } catch (e) {
          print('AUTH signup -> error general: $e'); //puse esto para probar 
          throw Exception('Error en registro: $e');
        }
      }
  
  //Verificar el Email 
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

    _accessToken = loginResponse.data['accessToken'];
    _refreshToken = loginResponse.data['refreshToken'];

    if (_accessToken == null) {
      throw Exception('No se obtuvo accessToken');
    }

    final roleValue = role.value;

    final insertResponse = await _dio.post(
      '$databaseBaseUrl/insert',
      data: {
        'tableName': 'Users',
        'records': [
          {
            'Email': email.trim(),
            'Name': name.trim(),
            'Role': roleValue,
          }
        ],
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final inserted = insertResponse.data['inserted'] as List<dynamic>? ?? [];
    final skipped = insertResponse.data['skipped'] as List<dynamic>? ?? [];

    if (inserted.isEmpty && skipped.isNotEmpty) {
      throw Exception('No se pudo guardar el perfil del usuario');
    }

    currentUser.value = AppUser(
      email: email.trim(),
      name: name.trim(),
      role: role,
    );
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ?? 'Error al verificar correo',
    );
  } catch (e) {
    throw Exception('Error al verificar correo: $e');
  }
}

  //Auth para el Iniciar sesion
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

      _accessToken = loginResponse.data['accessToken'];
      _refreshToken = loginResponse.data['refreshToken'];

      if (_accessToken == null) {
        throw Exception('No se obtuvo accessToken');
      }

      final readResponse = await _dio.get(
        '$databaseBaseUrl/read',
        queryParameters: {
          'tableName': 'Users',
          'Email': email.trim(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );

      final List<dynamic> users = readResponse.data;

      if (users.isEmpty) {
        throw Exception('No existe perfil para este usuario en la tabla Users');
      }

      final userData = users.first as Map<String, dynamic>;

      final role = appRoleFromString(userData['Role']?.toString() ?? '');

      currentUser.value = AppUser(
        email: userData['Email']?.toString() ?? email.trim(),
        name: userData['Name']?.toString() ?? '',
        role: role,
      );
    } on DioException catch (e) {
      final message = e.response?.data.toString() ?? e.message ?? 'Error de red';
      throw Exception('Error en login: $message');
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }
  
  //Auth para cerrar sesion
  Future<void> signOut() async {
    try {
      if (_accessToken != null) {
        await _dio.post(
          '$authBaseUrl/logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          ),
        );
      }
    } catch (_) {
    } finally {
      _accessToken = null;
      _refreshToken = null;
      currentUser.value = null;
    }
  }

  // Auth para leer el csv y crear los grupos
  Future<void> uploadCsvAndCreateGroups() async {
  try {
    if (_accessToken == null) {
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
    final rows = const CsvToListConverter().convert(csvString);

    if (rows.isEmpty) {
      throw Exception('El CSV está vacío');
    }

    final dataRows = rows.skip(1);
    final teacherEmail = currentUser.value?.email;

    if (teacherEmail == null) {
      throw Exception('No se encontró el docente autenticado');
    }

    final Set<String> createdGroups = {};

    for (final row in dataRows) {
      if (row.length < 8) continue;

      final groupCategoryName = row[0].toString().trim();
      final groupName = row[1].toString().trim();
      final groupCode = row[2].toString().trim();
      final parts = groupCode.split('_');
      final courseCode = parts.length >= 3 ? parts[2] : '';
      final username = row[3].toString().trim();
      final orgDefinedId = row[4].toString().trim();
      final firstName = row[5].toString().trim();
      final lastName = row[6].toString().trim();
      final studentEmail = row[7].toString().trim();
      final enrollmentDate = row.length > 8 ? row[8].toString().trim() : '';

      if (groupName.isEmpty || groupCode.isEmpty || studentEmail.isEmpty) {
        continue;
      }

      final studentName = '$firstName $lastName'.trim();

      if (!createdGroups.contains(groupCode)) {
        await _dio.post(
          '$databaseBaseUrl/insert',
          data: {
            'tableName': 'Groups',
            'records': [
              {
                'CourseCode': courseCode,
                'GroupName': groupName,
                'GroupCode': groupCode,
                'TeacherEmail': teacherEmail,
                'CreatedAt': DateTime.now().toIso8601String(),
              }
            ],
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $_accessToken',
            },
          ),
        );

        createdGroups.add(groupCode);
      }

      await _dio.post(
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
              'CreatedAt': DateTime.now().toIso8601String(),
            }
          ],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
    }
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Error subiendo CSV');
  } catch (e) {
    throw Exception('Error procesando CSV: $e');
  }
}


Future<List<Map<String, dynamic>>> getStudentGroups() async {
  try {
    if (_accessToken == null) {
      throw Exception('Usuario no autenticado');
    }

    final studentEmail = currentUser.value?.email;

    if (studentEmail == null) {
      throw Exception('No se encontró el correo del estudiante');
    }

    final response = await _dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'GroupMembers',
        'StudentEmail': studentEmail,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final List<dynamic> data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Error obteniendo grupos');
  } catch (e) {
    throw Exception('Error obteniendo grupos: $e');
  }
}

Future<List<Map<String, dynamic>>> getStudentGroupsWithPeers() async {
  try {
    if (_accessToken == null) {
      throw Exception('Usuario no autenticado');
    }

    final studentEmail = currentUser.value?.email;

    if (studentEmail == null) {
      throw Exception('No se encontró el correo del estudiante');
    }

    // 1. Buscar los grupos a los que pertenece el estudiante
    final myGroupsResponse = await _dio.get(
      '$databaseBaseUrl/read',
      queryParameters: {
        'tableName': 'GroupMembers',
        'StudentEmail': studentEmail,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    final List<dynamic> myGroupsData = myGroupsResponse.data;

    if (myGroupsData.isEmpty) {
      return [];
    }

    final List<Map<String, dynamic>> result = [];

    // 2. Por cada grupo, buscar todos los miembros y contar compañeros
    for (final item in myGroupsData) {
      final group = Map<String, dynamic>.from(item);

      final groupCode = group['GroupCode']?.toString() ?? '';
      final groupName = group['GroupName']?.toString() ?? 'Sin nombre';
      final teacherEmail = group['TeacherEmail']?.toString() ?? 'Sin docente';

      if (groupCode.isEmpty) continue;

      final membersResponse = await _dio.get(
        '$databaseBaseUrl/read',
        queryParameters: {
          'tableName': 'GroupMembers',
          'GroupCode': groupCode,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );

      final List<dynamic> membersData = membersResponse.data;

      final members =
          membersData.map((e) => Map<String, dynamic>.from(e)).toList();

      // Excluir al estudiante actual de la lista de compañeros
      final peers = members.where((member) {
        final email = member['StudentEmail']?.toString().trim().toLowerCase() ?? '';
        return email != studentEmail.trim().toLowerCase();
      }).toList();

      result.add({
        'GroupCode': groupCode,
        'GroupName': groupName,
        'TeacherEmail': teacherEmail,
        'PeerCount': peers.length,
        'Peers': peers,
      });
    }

    return result;
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ?? 'Error obteniendo grupos del estudiante',
    );
  } catch (e) {
    throw Exception('Error obteniendo grupos del estudiante: $e');
  }
}


}