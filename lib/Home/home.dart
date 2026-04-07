import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login.dart';
import '../controllers/authentication_controller.dart';
import '../features/assessments/ui/pages/student_assessment_page.dart';


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

  
  @override
  void initState() {
  super.initState();
  groupsFuture = authenticationController.getStudentGroupsWithPeers();
  assessmentsFuture = authenticationController.getStudentActiveAssessments();
  publishedResultsFuture = authenticationController.getStudentPublishedResults();
}

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);
    const greenLight = Color(0xFF93D977);
    const background = Color(0xFFF3F3F3);

    final user = authenticationController.currentUser.value;
    final userName = user?.name ?? 'Juan Sebastián';

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [greenDark, greenLight],
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
                              child: CircularProgressIndicator(),
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
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'No tienes evaluaciones activas en este momento',
                              style: TextStyle(fontSize: 16),
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
      await authenticationController.getStudentGroupsWithPeers();

  Map<String, dynamic>? selectedGroup;

  final normalizedAssessmentCode =
      courseCode.toString().trim().replaceAll('.0', '');

  for (final g in groups) {
    final gCourseCode = (g['CourseCode']?.toString() ?? '')
        .trim()
        .replaceAll('.0', '');

    if (gCourseCode == normalizedAssessmentCode) {
      selectedGroup = g;
      break;
    }
  }

  if (selectedGroup == null || selectedGroup.isEmpty) {
    Get.snackbar(
      'Error',
      'No se encontró tu grupo para este curso',
    );
    return;
  }

  final peers = (selectedGroup['Peers'] as List<dynamic>? ?? [])
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  final groupCode =
      selectedGroup['GroupCode']?.toString() ?? '';

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
                                    imageUrl:
                                        'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1200&q=80',
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                    const _SectionTag(text: 'Calificaciones Publicadas'),
const SizedBox(height: 18),

FutureBuilder<List<Map<String, dynamic>>>(
  future: publishedResultsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
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
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No tienes calificaciones publicadas todavía',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: results.map((result) {
          final courseCode = result['CourseCode']?.toString() ?? 'Sin curso';
          final generalAvg =
              (result['g_avg'] as num?)?.toDouble() ?? 0.0;

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _PublishedResultCard(
              title: 'Curso $courseCode',
              average: generalAvg,
            ),
          );
        }).toList(),
      ),
    );
  },
),

const SizedBox(height: 30),
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
                              child: CircularProgressIndicator(),
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
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'No perteneces a ningún grupo todavía',
                              style: TextStyle(fontSize: 16),
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
                            final peers = (group['Peers'] as List<dynamic>? ?? [])
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
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
      width: 180,
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
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

class _ExpandableGroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> peers;

  const _ExpandableGroupCard({
    required this.title,
    required this.subtitle,
    required this.peers,
  });

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);
    const borderGreen = Color(0xFFBFE0B4);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderGreen, width: 2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                color: Color(0xFF536D83),
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
                      borderRadius: BorderRadius.circular(8),
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
  final double average;

  const _PublishedResultCard({
    required this.title,
    required this.average,
  });

  Color getColor(double value) {
    if (value >= 4.5) return Colors.green;
    if (value >= 3.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);

    return Container(
      width: 200,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.assessment,
              size: 34,
              color: greenDark,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: greenDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
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
          ],
        ),
      ),
    );
  }
}