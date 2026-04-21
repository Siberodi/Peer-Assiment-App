enum AppRole {
  student,
  teacher,
}

extension AppRoleExtension on AppRole {
  String get label {
    switch (this) {
      case AppRole.student:
        return 'Estudiante';
      case AppRole.teacher:
        return 'Docente';
    }
  }

}

extension AppRoleMapper on AppRole {
  String get value {
    switch (this) {
      case AppRole.student:
        return 'estudiante';
      case AppRole.teacher:
        return 'docente';
    }
  }
}

AppRole appRoleFromString(String role) {
  switch (role.toLowerCase().trim()) {
    case 'estudiante':
      return AppRole.student;
    case 'docente':
      return AppRole.teacher;
    default:
      throw Exception('Rol inválido: $role');
  }
}


