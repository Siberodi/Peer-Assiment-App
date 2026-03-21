import '../core/app_role.dart';

class AppUser {
  final String email;
  //final String password;
  final String name;
  final AppRole role;

  const AppUser({
    required this.email,
    //required this.password,
    required this.name,
    required this.role,
  });
}