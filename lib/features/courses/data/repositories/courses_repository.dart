import '../../domain/models/course.dart';
import '../../domain/repositories/i_courses_repository.dart';
import '../datasources/remote/i_courses_source.dart';

class CoursesRepository implements ICoursesRepository {
  final ICoursesSource source;

  CoursesRepository({required this.source});

  @override
  Future<List<Course>> getTeacherCourses(
    String teacherEmail,
    String accessToken,
  ) async {
    final data = await source.getTeacherCourses(teacherEmail, accessToken);

    return data.map((item) {
      return Course(
        id: item['_id']?.toString() ?? '',
        courseCode: item['CourseCode']?.toString() ?? '',
        courseName: item['CourseName']?.toString() ?? '',
        teacherEmail: item['TeacherEmail']?.toString() ?? '',
        createdAt: item['CreatedAt']?.toString() ?? '',
      );
    }).toList();
  }

  @override
  Future<List<Course>> getStudentCourses(
    String studentEmail,
    String accessToken,
  ) async {
    final data = await source.getStudentCourses(studentEmail, accessToken);

    return data.map((item) {
      return Course(
        id: item['_id']?.toString() ?? '',
        courseCode: item['CourseCode']?.toString() ?? '',
        courseName: item['CourseName']?.toString() ?? 'Curso ${item['CourseCode']?.toString() ?? ''}',
        teacherEmail: item['TeacherEmail']?.toString() ?? '',
        createdAt: item['CreatedAt']?.toString() ?? '',
      );
    }).toList();
  }
}