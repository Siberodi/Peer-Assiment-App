import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peer_assiment_app_1/features/auth/ui/pages/login.dart';
import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/assessments/ui/pages/student_assessment_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationController authenticationController = Get.find();

  late Future<List<Map<String, dynamic>>> groupsFuture;
  late Future<List<Map<String, dynamic>>> assessmentsFuture;
  late Future<List<Map<String, dynamic>>> publishedResultsFuture;

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenLight = Color(0xFF93D977);
  static const Color greenSoft = Color(0xFFDCEFD3);
  static const Color background = Color(0xFFF3F3F3);
  static const Color subtitleColor = Color(0xFF5E738B);
  static const Color white = Colors.white;

  @override
  void initState() {
    super.initState();
    groupsFuture = authenticationController.getStudentGroupsWithPeers();
    assessmentsFuture = authenticationController.getStudentActiveAssessments();
    publishedResultsFuture =
        authenticationController.getStudentPublishedResults();
  }

  @override
  Widget build(BuildContext context) {
    final user = authenticationController.currentUser.value;
    final userName = user?.name ?? 'Estudiante';

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
                          color: white,
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
                        color: white,
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
                    const _SectionTag(text: 'Evaluaciones activas'),
                    const SizedBox(height: 18),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: assessmentsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                color: greenDark,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Error cargando evaluaciones: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final assessments = snapshot.data ?? [];

                        if (assessments.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: greenSoft,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'No tienes evaluaciones activas en este momento',
                              style: TextStyle(
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
                            children: assessments.map((assessment) {
                              final title =
                                  assessment['AssessmentName']?.toString() ??
                                      'Sin nombre';
                              final courseName =
                                  assessment['CourseName']?.toString() ??
                                      'Sin curso';
                              final endAtRaw =
                                  assessment['EndAt']?.toString() ?? '';
                              final endAt = endAtRaw.contains('T')
                                  ? endAtRaw.split('T').first
                                  : endAtRaw;
                              final assessmentId =
                                  assessment['_id']?.toString() ?? '';
                              final courseCode =
                                  assessment['CourseCode']?.toString() ?? '';

                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () async {
                                    final groups =
                                        await authenticationController
                                            .getStudentGroupsWithPeers();

                                    Map<String, dynamic>? selectedGroup;

                                    final normalizedAssessmentCode = courseCode
                                        .trim()
                                        .replaceAll('.0', '');

                                    for (final g in groups) {
                                      final gCourseCode =
                                          (g['CourseCode']?.toString() ?? '')
                                              .trim()
                                              .replaceAll('.0', '');

                                      if (gCourseCode ==
                                          normalizedAssessmentCode) {
                                        selectedGroup = g;
                                        break;
                                      }
                                    }

                                    if (selectedGroup == null ||
                                        selectedGroup.isEmpty) {
                                      Get.snackbar(
                                        'Error',
                                        'No se encontró tu grupo para este curso',
                                        backgroundColor: white,
                                        colorText: greenDark,
                                      );
                                      return;
                                    }

                                    final peers = (selectedGroup['Peers']
                                                    as List<dynamic>? ??
                                                [])
                                            .map((e) =>
                                                Map<String, dynamic>.from(e))
                                            .toList();

                                    final groupCode =
                                        selectedGroup['GroupCode']
                                                ?.toString() ??
                                            '';

                                    Get.to(
                                      () => StudentAssessmentPage(
                                        assessmentId: assessmentId,
                                        assessmentName: title,
                                        groupCode: groupCode,
                                        courseCode: normalizedAssessmentCode,
                                        peers: peers,
                                      ),
                                    );
                                  },
                                  child: _EvaluationCard(
                                    title: title,
                                    subtitle: '$courseName • Hasta $endAt',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const _SectionTag(text: 'Calificaciones Publicadas'),
                    const SizedBox(height: 18),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: publishedResultsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                color: greenDark,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Error cargando calificaciones: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final results = snapshot.data ?? [];

                        if (results.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: greenSoft,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'No tienes calificaciones publicadas todavía',
                              style: TextStyle(
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
                            children: results.map((result) {
                              final courseCode =
                                  result['CourseCode']?.toString() ??
                                      'Sin curso';

                              final assessmentName =
                                  result['AssessmentName']?.toString() ??
                                      'Evaluación';

                              final generalAvg =
                                  (result['g_avg'] as num?)?.toDouble() ?? 0.0;

                              final isFinal = result['IsFinal'] == true;

                              final resultMessage =
                                  result['ResultMessage']?.toString() ??
                                      (isFinal
                                          ? 'Resultado final'
                                          : 'Resultado provisional sujeto a cambios hasta que todos respondan.');

                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: _PublishedResultCard(
                                  title: assessmentName,
                                  subtitle: 'Curso $courseCode',
                                  average: generalAvg,
                                  isFinal: isFinal,
                                  message: resultMessage,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const _SectionTag(text: 'Mis Grupos'),
                    const SizedBox(height: 18),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: groupsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                color: greenDark,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Error cargando grupos: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final groups = snapshot.data ?? [];

                        if (groups.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: greenSoft,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'No perteneces a ningún grupo todavía',
                              style: TextStyle(
                                color: greenDark,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: groups.map((group) {
                            final groupName =
                                group['GroupName']?.toString() ?? 'Sin nombre';
                            final groupCode =
                                group['GroupCode']?.toString() ?? 'Sin código';
                            final peerCount = group['PeerCount'] as int? ?? 0;
                            final peers =
                                (group['Peers'] as List<dynamic>? ?? [])
                                    .map((e) => Map<String, dynamic>.from(e))
                                    .toList();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _ExpandableGroupCard(
                                title: groupName,
                                subtitle:
                                    'Código: $groupCode • $peerCount compañeros',
                                peers: peers,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
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

class _EvaluationCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EvaluationCard({
    required this.title,
    required this.subtitle,
  });

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenSoft = Color(0xFFDCEFD3);
  static const Color subtitleColor = Color(0xFF5E738B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
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
          const SizedBox(height: 8),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: subtitleColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableGroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> peers;

  const _ExpandableGroupCard({
    required this.title,
    required this.subtitle,
    required this.peers,
  });

  static const Color greenDark = Color(0xFF517A46);
  static const Color borderGreen = Color(0xFFBFE0B4);
  static const Color subtitleColor = Color(0xFF536D83);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderGreen, width: 2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          iconColor: greenDark,
          collapsedIconColor: greenDark,
          title: Text(
            title,
            style: const TextStyle(
              color: greenDark,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              subtitle,
              style: const TextStyle(
                color: subtitleColor,
                fontSize: 16,
              ),
            ),
          ),
          children: peers.isEmpty
              ? [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'No tienes compañeros en este grupo',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ]
              : peers.map((peer) {
                  final peerName =
                      peer['StudentName']?.toString() ?? 'Sin nombre';
                  final peerEmail =
                      peer['StudentEmail']?.toString() ?? 'Sin correo';

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFE8F3E3),
                          child: Icon(
                            Icons.person,
                            color: greenDark,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                peerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                peerEmail,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
        ),
      ),
    );
  }
}

class _PublishedResultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double average;
  final bool isFinal;
  final String message;

  const _PublishedResultCard({
    required this.title,
    required this.subtitle,
    required this.average,
    required this.isFinal,
    required this.message,
  });

  static const Color greenDark = Color(0xFF517A46);

  Color getColor(double value) {
    if (value >= 4.5) return const Color(0xFF517A46);
    if (value >= 3.5) return const Color(0xFF8B9E3C);
    return const Color(0xFFC96A4A);
  }

  Color getStatusColor() {
    return isFinal ? const Color(0xFF517A46) : const Color(0xFFC96A4A);
  }

  String getStatusText() {
    return isFinal ? 'Final' : 'Provisional';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.assessment_rounded,
            size: 34,
            color: greenDark,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: greenDark,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              getStatusText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: getColor(average),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              average.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}