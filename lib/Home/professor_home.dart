import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login.dart';
import '../controllers/authentication_controller.dart';
import 'upload_csv.dart';
import '../features/courses/ui/pages/teacher_courses_page.dart';

class ProfessorHomeScreen extends StatelessWidget {
  const ProfessorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);
    const greenLight = Color(0xFF93D977);
    const greenSoft = Color(0xFFDCEFD3);
    const background = Color(0xFFF3F3F3);

    final AuthenticationController authenticationController = Get.find();
    final user = authenticationController.currentUser.value;
    final userName = user?.name ?? 'Augusto';

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 170,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
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
                      onPressed: () {
                        authenticationController.signOut();
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
                        onPressed: () {
                          Get.to(() => const UploadCsvScreen());
                        },
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
                        onPressed: () {
                          Get.to(() => const TeacherCoursesPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenLight,
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
                    const _ProfessorActiveEvaluationsRow(),
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
    );
  }
}

class _SectionTag extends StatelessWidget {
  final String text;

  const _SectionTag({required this.text});

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);

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

class _ProfessorActiveEvaluationsRow extends StatelessWidget {
  const _ProfessorActiveEvaluationsRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: const Row(
        children: [
          _EvaluationCard(
            title: 'Programación Móvil 5432',
            subtitle: '1 Trabajo • 8 Grupos • Activo',
            imageUrl:
                'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1200&q=80',
          ),
          SizedBox(width: 16),
          _EvaluationCard(
            title: 'Programación Móvil 5430',
            subtitle: '1 Trabajo • 9 Grupos • Activo',
            imageUrl:
                'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1200&q=80',
          ),
        ],
      ),
    );
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
          _ReportCard(
            title: 'Programación Móvil',
            imageUrl:
                'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1200&q=80',
          ),
        ],
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const _EvaluationCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    color: Colors.black.withOpacity(0.35),
                    child: const Text(
                      'Class',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: greenDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const _ReportCard({
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);

    return Container(
      width: 185,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 110,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    color: Colors.black.withOpacity(0.35),
                    child: const Text(
                      'Reporte',
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
        ],
      ),
    );
  }
}