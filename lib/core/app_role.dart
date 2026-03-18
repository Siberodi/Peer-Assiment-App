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