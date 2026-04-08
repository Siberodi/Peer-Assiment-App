import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/app_user.dart';
import '../core/app_role.dart';

class AuthenticationController extends GetxController {
  final Rxn<AppUser> currentUser = Rxn<AppUser>();
  final Dio dio;

  AuthenticationController({Dio? dio}) : dio = dio ?? Dio();

  final String dbName = 'programacinmovil_project_3b5eaf6ff0';

  String get databaseBaseUrl =>
      'https://roble-api.openlab.uninorte.edu.co/database/$dbName';

  Future<List<Map<String, dynamic>>> getStudentGroupsWithPeers() async {
    final response = await dio.get('$databaseBaseUrl/read');

    final List data = response.data;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> signIn(String email, String password) async {
    // Implementación básica
    throw UnimplementedError('signIn not implemented');
  }

  Future<void> signUp(String email, String password, String name, AppRole role) async {
    // Implementación básica
    throw UnimplementedError('signUp not implemented');
  }

  Future<void> verifyEmailAndCompleteProfile(String email, String password, String name, AppRole role, String code) async {
    // Implementación básica
    throw UnimplementedError('verifyEmailAndCompleteProfile not implemented');
  }

  Future<void> uploadCsvAndCreateGroups() async {
    // Implementación básica
    throw UnimplementedError('uploadCsvAndCreateGroups not implemented');
  }

  void signOut() {
    currentUser.value = null;
  }
}