import 'package:peer_assiment_app_1/features/courses/domain/models/course.dart';
import 'package:peer_assiment_app_1/features/courses/domain/repositories/i_courses_repository.dart';
import 'package:peer_assiment_app_1/features/courses/data/datasources/local/i_courses_cache_source.dart';
import 'package:peer_assiment_app_1/features/courses/data/datasources/remote/i_courses_source.dart';

class CoursesRepository implements ICoursesRepository {
  final ICoursesSource source;
  final ICoursesCacheSource cacheSource;

  CoursesRepository({
    required this.source,
    required this.cacheSource,
  });

  Course _mapToCourse(Map<String, dynamic> item) {
    return Course(
      id: item['_id']?.toString() ?? '',
      courseCode: item['CourseCode']?.toString() ?? '',
      courseName: item['CourseName']?.toString() ??
          'Curso ${item['CourseCode']?.toString() ?? ''}',
      teacherEmail: item['TeacherEmail']?.toString() ?? '',
      createdAt: item['CreatedAt']?.toString() ?? '',
    );
  }

  @override
  Future<List<Course>> getTeacherCourses(
    String teacherEmail,
    String accessToken, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        await cacheSource.isTeacherCoursesCacheValid(teacherEmail)) {
      final cached = await cacheSource.getCachedTeacherCourses(teacherEmail);
      return cached.map(_mapToCourse).toList();
    }

    final data = await source.getTeacherCourses(teacherEmail, accessToken);
    await cacheSource.cacheTeacherCourses(teacherEmail, data);

    return data.map(_mapToCourse).toList();
  }

  @override
  Future<List<Course>> getStudentCourses(
    String studentEmail,
    String accessToken, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        await cacheSource.isStudentCoursesCacheValid(studentEmail)) {
      final cached = await cacheSource.getCachedStudentCourses(studentEmail);
      return cached.map(_mapToCourse).toList();
    }

    final data = await source.getStudentCourses(studentEmail, accessToken);
    await cacheSource.cacheStudentCourses(studentEmail, data);

    return data.map(_mapToCourse).toList();
  }
}