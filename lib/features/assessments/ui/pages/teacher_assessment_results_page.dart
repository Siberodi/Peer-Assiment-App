import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../data/datasources/remote/assessments_source_service.dart';
import '../../data/repositories/assessments_repository.dart';
import '../viewmodels/assessments_controller.dart';

class TeacherAssessmentResultsPage extends StatefulWidget {
  final String assessmentId;
  final String assessmentName;

  const TeacherAssessmentResultsPage({
    super.key,
    required this.assessmentId,
    required this.assessmentName,
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

  @override
  void initState() {
    super.initState();

    final source = AssessmentsSourceService(
      dio: Dio(),
      databaseBaseUrl: authController.databaseBaseUrl,
    );

    final repository = AssessmentsRepository(source: source);

    controller = Get.put(
      AssessmentsController(repository: repository),
      tag: 'results_${widget.assessmentId}',
    );

    final accessToken = authController.accessToken!;

    responsesFuture = controller.getAssessmentResponses(
      accessToken: accessToken,
      assessmentId: widget.assessmentId,
    );
  }

  Map<String, Map<String, dynamic>> buildAverages(
    List<Map<String, dynamic>> responses,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final response in responses) {
      final email = response['EvaluatedEmail']?.toString() ?? '';
      if (email.isEmpty) continue;

      grouped.putIfAbsent(email, () => []);
      grouped[email]!.add(response);
    }

    final Map<String, Map<String, dynamic>> result = {};

    grouped.forEach((email, items) {
      final name = items.first['EvaluatedName']?.toString() ?? 'Sin nombre';

      double pAvg = 0;
      double cAvg = 0;
      double cmAvg = 0;
      double aAvg = 0;

      for (final item in items) {
        pAvg += (item['p_score'] as num).toDouble();
        cAvg += (item['c_score'] as num).toDouble();
        cmAvg += (item['cm_score'] as num).toDouble();
        aAvg += (item['a_score'] as num).toDouble();
      }

      final count = items.length;
      pAvg /= count;
      cAvg /= count;
      cmAvg /= count;
      aAvg /= count;

      final generalAvg = (pAvg + cAvg + cmAvg + aAvg) / 4;

      result[email] = {
        'name': name,
        'pAvg': pAvg,
        'cAvg': cAvg,
        'cmAvg': cmAvg,
        'aAvg': aAvg,
        'generalAvg': generalAvg,
      };
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.assessmentName),
          backgroundColor: greenDark,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: publishResults,
              icon: const Icon(Icons.publish),
            ),
          ],
        ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: responsesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final responses = snapshot.data ?? [];

          if (responses.isEmpty) {
            return const Center(
              child: Text('No hay respuestas todavía'),
            );
          }

          final averages = buildAverages(responses);
          final students = averages.values.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Punctuality: ${student['pAvg'].toStringAsFixed(2)}'),
                      Text('Contributions: ${student['cAvg'].toStringAsFixed(2)}'),
                      Text('Commitment: ${student['cmAvg'].toStringAsFixed(2)}'),
                      Text('Attitude: ${student['aAvg'].toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text(
                        'Promedio general: ${student['generalAvg'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Future<void> publishResults() async {
  final accessToken = authController.accessToken;

  if (accessToken == null) {
    Get.snackbar('Error', 'Usuario no autenticado');
    return;
  }

  final responses = await controller.getAssessmentResponses(
    accessToken: accessToken,
    assessmentId: widget.assessmentId,
  );

  if (responses.isEmpty) {
    Get.snackbar('Error', 'No hay respuestas para publicar');
    return;
  }

  final Map<String, List<Map<String, dynamic>>> responsesByGroup = {};

  for (final response in responses) {
    final groupCode = response['GroupCode']?.toString() ?? '';
    if (groupCode.isEmpty) continue;

    responsesByGroup.putIfAbsent(groupCode, () => []);
    responsesByGroup[groupCode]!.add(response);
  }

  final List<Map<String, dynamic>> finalResults = [];

  for (final entry in responsesByGroup.entries) {
    final groupCode = entry.key;
    final groupResponses = entry.value;

    final members = await controller.getGroupMembers(
      accessToken: accessToken,
      groupCode: groupCode,
    );

    final totalMembers = members.length;
    final expectedResponses = totalMembers * (totalMembers - 1);

    if (groupResponses.length < expectedResponses) {
      Get.snackbar(
        'No se puede publicar',
        'El grupo $groupCode aún no ha completado todas las respuestas.',
      );
      return;
    }

    final Map<String, List<Map<String, dynamic>>> byEvaluatedStudent = {};

    for (final response in groupResponses) {
      final email = response['EvaluatedEmail']?.toString() ?? '';
      if (email.isEmpty) continue;

      byEvaluatedStudent.putIfAbsent(email, () => []);
      byEvaluatedStudent[email]!.add(response);
    }

    for (final studentEntry in byEvaluatedStudent.entries) {
      final studentEmail = studentEntry.key;
      final items = studentEntry.value;

      final studentName =
          items.first['EvaluatedName']?.toString() ?? 'Sin nombre';
      final courseCode =
          items.first['CourseCode']?.toString() ?? '';

      double pAvg = 0;
      double cAvg = 0;
      double cmAvg = 0;
      double aAvg = 0;

      for (final item in items) {
        pAvg += (item['p_score'] as num).toDouble();
        cAvg += (item['c_score'] as num).toDouble();
        cmAvg += (item['cm_score'] as num).toDouble();
        aAvg += (item['a_score'] as num).toDouble();
      }

      final count = items.length;
      pAvg /= count;
      cAvg /= count;
      cmAvg /= count;
      aAvg /= count;

      final gAvg = (pAvg + cAvg + cmAvg + aAvg) / 4;

      finalResults.add({
        'AssessmentId': widget.assessmentId,
        'StudentEmail': studentEmail,
        'StudentName': studentName,
        'GroupCode': groupCode,
        'CourseCode': int.tryParse(courseCode) ?? courseCode,
        'p_avg': pAvg,
        'c_avg': cAvg,
        'cm_avg': cmAvg,
        'a_avg': aAvg,
        'g_avg': gAvg,
        'Published': true,
        'CreatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  await controller.publishAssessmentResults(
    accessToken: accessToken,
    records: finalResults,
  );

  if (controller.errorMessage.value.isNotEmpty) {
    Get.snackbar('Error', controller.errorMessage.value);
    return;
  }

  Get.snackbar('Éxito', 'Resultados publicados correctamente');
}
}