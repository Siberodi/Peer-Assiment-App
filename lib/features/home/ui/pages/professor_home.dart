import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:peer_assiment_app_1/features/auth/ui/pages/login.dart';
import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/home/ui/pages/upload_csv.dart';
import 'package:peer_assiment_app_1/features/courses/ui/pages/teacher_courses_page.dart';
import 'package:peer_assiment_app_1/features/assessments/data/datasources/remote/assessments_source_service.dart';
import 'package:peer_assiment_app_1/features/assessments/data/repositories/assessments_repository.dart';
import 'package:peer_assiment_app_1/features/assessments/ui/viewmodels/assessments_controller.dart';
import 'package:peer_assiment_app_1/features/assessments/ui/pages/teacher_assessment_results_page.dart';

class ProfessorHomeScreen extends StatefulWidget {
  const ProfessorHomeScreen({super.key});

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  final AuthenticationController authenticationController = Get.find();
  late final AssessmentsController assessmentsController;

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenLight = Color(0xFF93D977);
  static const Color greenSoft = Color(0xFFDCEFD3);
  static const Color background = Color(0xFFF3F3F3);
  static const Color subtitleColor = Color(0xFF5E738B);

  Future<void> _reloadTeacherAssessments() async {
    final accessToken = authenticationController.accessToken;
    final teacherEmail = authenticationController.currentUser.value?.email;

    if (accessToken != null && teacherEmail != null) {
      await assessmentsController.loadTeacherAssessments(
        accessToken: accessToken,
        teacherEmail: teacherEmail,
      );
    }
  }

  Future<void> _handleCsvUpload() async {
    final uploaded = await Get.to<bool>(() => const UploadCsvScreen());

    if (uploaded == true) {
      await _reloadTeacherAssessments();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final source = AssessmentsSourceService(
      dioClient: Dio(),
      databaseBaseUrl: authenticationController.databaseBaseUrl,
      authController: authenticationController,
    );

    final repository = AssessmentsRepository(source: source);

    assessmentsController = Get.put(
      AssessmentsController(repository: repository),
      tag: 'professor_home_assessments',
    );

    _reloadTeacherAssessments();
  }

  @override
  Widget build(BuildContext context) {
    final user = authenticationController.currentUser.value;
    final userName = user?.name ?? 'Profesor';

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _reloadTeacherAssessments,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 170,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 22,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [greenLight, greenDark],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hola,\n$userName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await authenticationController.signOut();
                          Get.offAll(() => const LoginScreen());
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 26, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTag(text: 'Acciones del docente'),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _handleCsvUpload,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenSoft,
                            foregroundColor: greenDark,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.upload_file_rounded),
                          label: const Text(
                            'Subir CSV de grupos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Get.to(() => const TeacherCoursesPage());
                            await _reloadTeacherAssessments();
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenDark,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.menu_book_rounded),
                          label: const Text(
                            'Mis Cursos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const _SectionTag(text: 'Evaluaciones activas'),
                      const SizedBox(height: 18),
                      _ProfessorAssessmentsRow(
                        controller: assessmentsController,
                        showActive: true,
                      ),
                      const SizedBox(height: 30),
                      const _SectionTag(text: 'Evaluaciones inactivas'),
                      const SizedBox(height: 18),
                      _ProfessorAssessmentsRow(
                        controller: assessmentsController,
                        showActive: false,
                      ),
                      const SizedBox(height: 30),
                      const _SectionTag(text: 'Calificaciones Publicadas'),
                      const SizedBox(height: 18),
                      const _ProfessorPublishedReportsRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTag extends StatelessWidget {
  final String text;

  const _SectionTag({required this.text});

  static const Color greenDark = Color(0xFF517A46);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: greenDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfessorAssessmentsRow extends StatelessWidget {
  final AssessmentsController controller;
  final bool showActive;

  const _ProfessorAssessmentsRow({
    required this.controller,
    required this.showActive,
  });

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenSoft = Color(0xFFDCEFD3);
  static const Color subtitleColor = Color(0xFF5E738B);

  bool _isAssessmentActive(dynamic assessment) {
    final now = DateTime.now();

    final bool status = assessment.status == true;
    final DateTime? start = DateTime.tryParse(assessment.startAt);
    final DateTime? end = DateTime.tryParse(assessment.endAt);

    if (!status) return false;
    if (start == null || end == null) return false;

    return now.isAfter(start) && now.isBefore(end);
  }

  String _buildSubtitle(dynamic assessment, bool isActive) {
    final start = assessment.startAt.toString();
    final end = assessment.endAt.toString();

    final startText = start.contains('T') ? start.split('T').first : start;
    final endText = end.contains('T') ? end.split('T').first : end;

    return 'Curso ${assessment.courseCode} • ${isActive ? 'Activa' : 'Inactiva'}\n$startText - $endText';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(color: greenDark),
          ),
        );
      }

      final filteredAssessments = controller.assessments.where((a) {
        final isActive = _isAssessmentActive(a);
        return showActive ? isActive : !isActive;
      }).toList();

      if (filteredAssessments.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: greenSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            showActive
                ? 'No hay evaluaciones activas'
                : 'No hay evaluaciones inactivas',
            style: const TextStyle(
              color: greenDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filteredAssessments.map((assessment) {
            final isActive = _isAssessmentActive(assessment);

            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _EvaluationCard(
                title: assessment.assessmentName,
                subtitle: _buildSubtitle(assessment, isActive),
                isActive: isActive,
                onTap: () {
                  Get.to(
                    () => TeacherAssessmentResultsPage(
                      assessmentId: assessment.id,
                      assessmentName: assessment.assessmentName,
                      controllerTag: 'professor_home_assessments',
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

class _ProfessorPublishedReportsRow extends StatelessWidget {
  const _ProfessorPublishedReportsRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: const Row(
        children: [
          _ReportCard(title: 'Programación Móvil'),
        ],
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  const _EvaluationCard({
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  });

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenSoft = Color(0xFFDCEFD3);
  static const Color subtitleColor = Color(0xFF5E738B);

  Color _statusColor() {
    return isActive ? const Color(0xFF517A46) : const Color(0xFFC96A4A);
  }

  String _statusText() {
    return isActive ? 'Activa' : 'Inactiva';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: greenSoft,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.assignment_turned_in_rounded,
              color: greenDark,
              size: 28,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: greenDark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _statusText(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: subtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;

  const _ReportCard({
    required this.title,
  });

  static const Color greenDark = Color(0xFF517A46);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: greenDark,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}