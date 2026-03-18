import 'package:get/get.dart';
import '../core/app_role.dart';
import '../models/app_user.dart';

class AuthenticationController extends GetxController {
  final RxList<AppUser> _users = <AppUser>[].obs;
  final Rxn<AppUser> currentUser = Rxn<AppUser>();

  List<AppUser> get users => _users;

  AppUser? _findUserByEmail(String email) {
    for (final user in _users) {
      if (user.email.trim().toLowerCase() == email.trim().toLowerCase()) {
        return user;
      }
    }
    return null;
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    AppRole role,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final existingUser = _findUserByEmail(email);
    if (existingUser != null) {
      throw Exception('Ya existe una cuenta con ese correo');
    }

    final user = AppUser(
      email: email.trim(),
      password: password,
      name: name.trim(),
      role: role,
    );

    _users.add(user);
    currentUser.value = user;
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final user = _findUserByEmail(email);

    if (user == null) {
      throw Exception('No existe una cuenta con ese correo');
    }

    if (user.password != password) {
      throw Exception('Contraseña incorrecta');
    }

    currentUser.value = user;
  }

  void signOut() {
    currentUser.value = null;
  }
}