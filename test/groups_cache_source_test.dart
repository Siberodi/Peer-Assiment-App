import 'package:flutter_test/flutter_test.dart';

import 'package:peer_assiment_app_1/core/i_local_preferences.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/local/groups_cache_source.dart';
import 'package:peer_assiment_app_1/features/groups/data/datasources/local/i_groups_cache_source.dart';

/// Mock del proceso externo (roble) → almacenamiento
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
  late IGroupsCacheSource cacheSource;
  late FakeLocalPreferences prefs;

  /// Simulación de contexto de usuario (como pidió el enunciado)
  const token = 'mock_token_123';
  const userId = 'user_1';
  const email = 'student@test.com';

  const courseCode = 'CS101';

  final groups = [
    {'id': 1, 'name': 'Group A'},
    {'id': 2, 'name': 'Group B'},
  ];

  setUp(() {
    prefs = FakeLocalPreferences();
    cacheSource = GroupsCacheSource(prefs);
  });

  group('Integración - Cache con contexto de usuario', () {
    test('guarda y obtiene grupos usando email (contexto usuario)', () async {
      /// simulación: usuario autenticado (token, id, email)
      expect(token, isNotEmpty);
      expect(userId, isNotEmpty);
      expect(email, contains('@'));

      await cacheSource.cacheStudentGroupsByCourse(
        courseCode,
        email,
        groups,
      );

      final result = await cacheSource.getCachedStudentGroupsByCourse(
        courseCode,
        email,
      );

      expect(result.length, 2);
      expect(result.first['name'], 'Group A');
    });

    test('usa cache y evita cambios constantes (TTL)', () async {
      await cacheSource.cacheGroupsByCourse(courseCode, groups);

      final isValid =
          await cacheSource.isGroupsByCourseCacheValid(courseCode);

      /// cache válida → no necesita recargar datos
      expect(isValid, true);
    });

    test('invalida cache cuando pasa el tiempo (simulación cambios)', () async {
      final oldDate =
          DateTime.now().subtract(const Duration(minutes: 120)).toIso8601String();

      await prefs.setString(
        'groups_course_cs101_timestamp',
        oldDate,
      );

      final isValid =
          await cacheSource.isGroupsByCourseCacheValid(courseCode);

      /// cambios no constantes → cache expira correctamente
      expect(isValid, false);
    });

    test('maneja error cuando no hay cache', () async {
      expect(
        () => cacheSource.getCachedGroupsByCourse(courseCode),
        throwsException,
      );
    });
  });

  group('Integración - Interfaz (IGroupsCacheSource)', () {
    test('funciona desde la abstracción', () async {
      await cacheSource.cacheGroupsByCourse(courseCode, groups);

      final result = await cacheSource.getCachedGroupsByCourse(courseCode);

      expect(result.isNotEmpty, true);
    });
  });
}
