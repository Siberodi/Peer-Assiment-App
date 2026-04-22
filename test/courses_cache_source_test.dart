import 'package:flutter_test/flutter_test.dart';

import 'package:peer_assiment_app_1/core/i_local_preferences.dart';
import 'package:peer_assiment_app_1/features/courses/data/datasources/local/courses_cache_source.dart';
import 'package:peer_assiment_app_1/features/courses/data/datasources/local/i_courses_cache_source.dart';

/// Mock del proceso externo (roble)
class FakeLocalPreferences implements ILocalPreferences {
  final Map<String, String> _storage = {};

  @override
  Future<String?> getString(String key) async => _storage[key];

  @override
  Future<void> setString(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }
}

void main() {
  late ICoursesCacheSource cacheSource;
  late FakeLocalPreferences prefs;

  /// Contexto de usuario (lo que te pidieron)
  const token = 'mock_token_123';
  const userId = 'user_1';
  const email = 'teacher@test.com';

  final courses = [
    {'id': 1, 'name': 'Math'},
    {'id': 2, 'name': 'Science'},
  ];

  setUp(() {
    prefs = FakeLocalPreferences();
    cacheSource = CoursesCacheSource(prefs);
  });

  group('Integración - Cache de cursos (Teacher)', () {
    test('guarda y obtiene cursos usando email', () async {
      /// Validación de contexto usuario
      expect(token, isNotEmpty);
      expect(userId, isNotEmpty);
      expect(email, contains('@'));

      await cacheSource.cacheTeacherCourses(email, courses);

      final result = await cacheSource.getCachedTeacherCourses(email);

      expect(result.length, 2);
      expect(result.first['name'], 'Math');
    });

    test('usa cache válida (TTL)', () async {
      await cacheSource.cacheTeacherCourses(email, courses);

      final isValid =
          await cacheSource.isTeacherCoursesCacheValid(email);

      expect(isValid, true);
    });

    test('invalida cache cuando expira', () async {
      final oldDate =
          DateTime.now().subtract(const Duration(minutes: 120)).toIso8601String();

      await prefs.setString(
        'teacher_courses_teacher@test.com_timestamp',
        oldDate,
      );

      final isValid =
          await cacheSource.isTeacherCoursesCacheValid(email);

      expect(isValid, false);
    });

    test('lanza error si no hay cache', () async {
      expect(
        () => cacheSource.getCachedTeacherCourses(email),
        throwsException,
      );
    });
  });

  group('Integración - Cache de cursos (Student)', () {
    test('guarda y obtiene cursos de estudiante', () async {
      await cacheSource.cacheStudentCourses(email, courses);

      final result = await cacheSource.getCachedStudentCourses(email);

      expect(result.isNotEmpty, true);
      expect(result.first['name'], 'Math');
    });

    test('elimina cache correctamente', () async {
      await cacheSource.cacheStudentCourses(email, courses);

      await cacheSource.clearStudentCoursesCache(email);

      expect(
        () => cacheSource.getCachedStudentCourses(email),
        throwsException,
      );
    });

    test('valida cache de estudiante dentro del TTL', () async {
      await cacheSource.cacheStudentCourses(email, courses);

      final isValid =
          await cacheSource.isStudentCoursesCacheValid(email);

      expect(isValid, true);
    });
  });

  group('Integración - Interfaz (ICoursesCacheSource)', () {
    test('funciona desde la abstracción', () async {
      await cacheSource.cacheTeacherCourses(email, courses);

      final result = await cacheSource.getCachedTeacherCourses(email);

      expect(result.isNotEmpty, true);
    });
  });
}
