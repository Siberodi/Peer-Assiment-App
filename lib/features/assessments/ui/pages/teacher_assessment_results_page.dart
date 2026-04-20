import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/authentication_controller.dart';
import '../viewmodels/assessments_controller.dart';

class TeacherAssessmentResultsPage extends StatefulWidget {
  final String assessmentId;
  final String assessmentName;
  final String controllerTag;

  const TeacherAssessmentResultsPage({
    super.key,
    required this.assessmentId,
    required this.assessmentName,
    this.controllerTag = 'professor_home_assessments',
  });

  @override
  State<TeacherAssessmentResultsPage> createState() =>
      _TeacherAssessmentResultsPageState();
}

class _TeacherAssessmentResultsPageState
    extends State<TeacherAssessmentResultsPage> {
  final authController = Get.find<AuthenticationController>();
  late final AssessmentsController controller;

  late Future<List<Map<String, dynamic>>> responsesFuture;

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenLight = Color(0xFFCAEDC0);
  static const Color background = Color(0xFFF3F3F3);
  static const Color subtitleColor = Color(0xFF5E738B);
  static const Color white = Colors.white;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AssessmentsController>(tag: widget.controllerTag);
    responsesFuture = _loadResponses();
  }

  Future<List<Map<String, dynamic>>> _loadResponses() async {
    final accessToken = authController.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Usuario no autenticado');
    }

    return controller.getAssessmentResponses(
      accessToken: accessToken,
      assessmentId: widget.assessmentId,
    );
  }

  void _refreshResponses() {
    setState(() {
      responsesFuture = _loadResponses();
    });
  }

  String formatScore(dynamic value) {
    if (value == null) return '0.00';
    if (value is num) return value.toStringAsFixed(2);
    return '0.00';
  }

  Future<void> publishResults() async {
    final accessToken = authController.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      Get.snackbar(
        'Error',
        'Usuario no autenticado',
        backgroundColor: white,
        colorText: greenDark,
      );
      return;
    }

    try {
      final finalResults = await controller.buildPublishableResults(
        accessToken: accessToken,
        assessmentId: widget.assessmentId,
      );

      await controller.publishAssessmentResults(
        accessToken: accessToken,
        records: finalResults,
      );

      if (controller.errorMessage.value.isNotEmpty) {
        Get.snackbar(
          'Error',
          controller.errorMessage.value,
          backgroundColor: white,
          colorText: greenDark,
        );
        return;
      }

      Get.snackbar(
        'Éxito',
        'Resultados publicados correctamente',
        backgroundColor: white,
        colorText: greenDark,
      );

      _refreshResponses();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: white,
        colorText: greenDark,
      );
    }
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8ED973), greenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 210,
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 16,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: white,
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Positioned(
                top: 14,
                right: 16,
                child: IconButton(
                  onPressed: publishResults,
                  icon: const Icon(Icons.publish_rounded),
                  color: white,
                  iconSize: 30,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: Text(
                    widget.assessmentName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMetricRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: subtitleColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: greenDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStudentCard(Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: greenLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student['name'] ?? 'Sin nombre',
            style: const TextStyle(
              color: greenDark,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          buildMetricRow(
            label: 'Puntualidad',
            value: formatScore(student['pAvg']),
          ),
          buildMetricRow(
            label: 'Calidad de trabajo',
            value: formatScore(student['cAvg']),
          ),
          buildMetricRow(
            label: 'Compromiso',
            value: formatScore(student['cmAvg']),
          ),
          buildMetricRow(
            label: 'Convivencia',
            value: formatScore(student['aAvg']),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Promedio general',
                    style: TextStyle(
                      color: greenDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  formatScore(student['generalAvg']),
                  style: const TextStyle(
                    color: greenDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No hay respuestas todavía',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greenDark,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: responsesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: greenDark,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                final responses = snapshot.data ?? [];

                if (responses.isEmpty) {
                  return buildEmptyState();
                }

                final averages = controller.buildAverages(responses);
                final students = averages.values.toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return buildStudentCard(student);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}