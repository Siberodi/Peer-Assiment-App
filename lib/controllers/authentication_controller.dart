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
  
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

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

    final Set<String> createdCourses = {};
    final Set<String> createdGroups = {};
    final Set<String> createdCourseStudents = {};
    final Set<String> createdGroupMembers = {};

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

      if (courseCode.isEmpty || groupName.isEmpty || groupCode.isEmpty || studentEmail.isEmpty) {
        continue;
      }

      final studentName = '$firstName $lastName'.trim();
      final courseName = 'Curso $courseCode';

      // 1. Crear curso si no existe en esta carga
      if (!createdCourses.contains(courseCode)) {
        await _dio.post(
          '$databaseBaseUrl/insert',
          data: {
            'tableName': 'Courses',
            'records': [
              {
                'CourseCode': courseCode,
                'CourseName': courseName,
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

        createdCourses.add(courseCode);
      }

      // 2. Crear grupo si no existe en esta carga
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

      // 3. Insertar estudiante en CourseStudents si no existe en esta carga
      final courseStudentKey = '$courseCode|$studentEmail';

      if (!createdCourseStudents.contains(courseStudentKey)) {
        await _dio.post(
          '$databaseBaseUrl/insert',
          data: {
            'tableName': 'CourseStudents',
            'records': [
              {
                'CourseCode': courseCode,
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

        createdCourseStudents.add(courseStudentKey);
      }

      // 4. Insertar estudiante en GroupMembers si no existe en esta carga
      final groupMemberKey = '$groupCode|$studentEmail';

      if (!createdGroupMembers.contains(groupMemberKey)) {
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

        createdGroupMembers.add(groupMemberKey);
      }
    }
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Error subiendo CSV');
  } catch (e) {
    throw Exception('Error procesando CSV: $e');
  }
}


 // Encontrar los companeros del grupo
  Future<List<Map<String, dynamic>>> getStudentGroupsWithPeers() async {
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

    final List<dynamic> myMemberships = response.data;

    if (myMemberships.isEmpty) {
      return [];
    }

    final List<Map<String, dynamic>> result = [];

    for (final membership in myMemberships) {
      final groupCode = membership['GroupCode']?.toString() ?? '';
      final groupName = membership['GroupName']?.toString() ?? '';
      final courseCode = membership['CourseCode']?.toString() ?? '';
      final teacherEmail = membership['TeacherEmail']?.toString() ?? '';

      final peersResponse = await _dio.get(
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

      final List<dynamic> allMembers = peersResponse.data;

      final peers = allMembers
          .map((e) => Map<String, dynamic>.from(e))
          .where((member) =>
              (member['StudentEmail']?.toString() ?? '').trim().toLowerCase() !=
              studentEmail.trim().toLowerCase())
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
  } on DioException catch (e) {
    throw Exception(
      e.response?.data.toString() ?? 'Error obteniendo grupos con compañeros',
    );
  } catch (e) {
    throw Exception('Error obteniendo grupos con compañeros: $e');
  }
}

  // Mostrar Evaluacion activa al estudiante
  Future<List<Map<String, dynamic>>> getStudentActiveAssessments() async {
  try {
    if (_accessToken == null) {
      throw Exception('Usuario no autenticado');
    }

    final studentEmail = currentUser.value?.email;

    if (studentEmail == null) {
      throw Exception('No se encontró el correo del estudiante');
    }

    //Obtener grupos del estudiante
    final groups = await getStudentGroupsWithPeers();

    if (groups.isEmpty) {
      return [];
    }

    final List<Map<String, dynamic>> assessments = [];

    // Buscar evaluaciones por cada curso
    for (final group in groups) {
      final courseCode = group['CourseCode']?.toString() ?? '';

      final response = await _dio.get(
        '$databaseBaseUrl/read',
        queryParameters: {
          'tableName': 'Assessments',
          'CourseCode': courseCode,
          'Status': true,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );

      final List<dynamic> data = response.data;

      for (final e in data) {
        final assessment = Map<String, dynamic>.from(e);

        //Filtrar por fecha activa
        final now = DateTime.now();
        final start = DateTime.tryParse(assessment['StartAt'] ?? '');
        final end = DateTime.tryParse(assessment['EndAt'] ?? '');

        if (start != null && end != null) {
          if (now.isAfter(start) && now.isBefore(end)) {
            assessments.add(assessment);
          }
        }
      }
    }

    return assessments;
  } on DioException catch (e) {
    throw Exception(
      e.response?.data.toString() ??
          'Error obteniendo evaluaciones activas',
    );
  } catch (e) {
    throw Exception('Error obteniendo evaluaciones activas: $e');
  }
}
Future<List<Map<String, dynamic>>> getStudentPublishedResults() async {
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
        'tableName': 'AssessmentResults',
        'StudentEmail': studentEmail,
        'Published': true,
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
    throw Exception(
      e.response?.data.toString() ??
          'Error obteniendo calificaciones publicadas',
    );
  } catch (e) {
    throw Exception('Error obteniendo calificaciones publicadas: $e');
  }
}

}