import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../data/datasources/remote/assessments_source_service.dart';
import '../../data/repositories/assessments_repository.dart';
import '../viewmodels/assessments_controller.dart';

class StudentAssessmentPage extends StatefulWidget {
  final String assessmentId;
  final String groupCode;
  final String courseCode;
  final String assessmentName;
  final List<Map<String, dynamic>> peers;

  const StudentAssessmentPage({
    super.key,
    required this.assessmentId,
    required this.groupCode,
    required this.courseCode,
    required this.assessmentName,
    required this.peers,
  });

  @override
  State<StudentAssessmentPage> createState() => _StudentAssessmentPageState();
}

class _StudentAssessmentPageState extends State<StudentAssessmentPage> {
  final authController = Get.find<AuthenticationController>();
  late final AssessmentsController assessmentsController;

  final Map<String, Map<String, int>> responses = {};

  bool alreadySubmitted = false;
  bool checkingSubmission = true;

  final List<Map<String, dynamic>> punctualityRubric = [
    {
      'value': 2,
      'label': 'Needs Improvement',
      'description':
          'Llegó tarde a todas las sesiones o se estuvo ausentando constantemente lo cual afectó el trabajo del equipo.',
    },
    {
      'value': 3,
      'label': 'Adequate',
      'description':
          'Llegó tarde con mucha frecuencia y se ausentó varias veces del trabajo del equipo.',
    },
    {
      'value': 4,
      'label': 'Good',
      'description':
          'En la mayoría de las sesiones llegó puntualmente y no se ausentó con frecuencia.',
    },
    {
      'value': 5,
      'label': 'Excellent',
      'description': 'Acudió puntualmente a todas las sesiones de trabajo.',
    },
  ];

  final List<Map<String, dynamic>> contributionsRubric = [
    {
      'value': 2,
      'label': 'Needs Improvement',
      'description':
          'En todo momento estuvo como observador y no aportó al trabajo del equipo.',
    },
    {
      'value': 3,
      'label': 'Adequate',
      'description':
          'En algunas ocasiones participó dentro del equipo y en los intercambios generales.',
    },
    {
      'value': 4,
      'label': 'Good',
      'description':
          'Hizo varios aportes al equipo; sin embargo, puede ser más crítico y propositivo.',
    },
    {
      'value': 5,
      'label': 'Excellent',
      'description':
          'Sus aportes fueron muy acertados y enriquecieron en todo momento el trabajo del equipo.',
    },
  ];

  final List<Map<String, dynamic>> commitmentRubric = [
    {
      'value': 2,
      'label': 'Needs Improvement',
      'description':
          'Mostró poco compromiso con las tareas y roles asignados tanto por el profesor como por los miembros del equipo.',
    },
    {
      'value': 3,
      'label': 'Adequate',
      'description':
          'En algunos momentos observamos que su compromiso con el trabajo disminuyó, y le afectó para afrontar las tareas propuestas.',
    },
    {
      'value': 4,
      'label': 'Good',
      'description':
          'La mayor parte del tiempo asumió tareas con responsabilidad y compromiso pero pudo haber aportado más al trabajo del equipo.',
    },
    {
      'value': 5,
      'label': 'Excellent',
      'description':
          'Mostró en todo momento un compromiso serio con las tareas asignadas y los roles que tuvo en el equipo.',
    },
  ];

  final List<Map<String, dynamic>> attitudeRubric = [
    {
      'value': 2,
      'label': 'Needs Improvement',
      'description':
          'Mantuvo una actitud negativa hacia las actividades del taller y a las tareas del equipo.',
    },
    {
      'value': 3,
      'label': 'Adequate',
      'description':
          'En algunas oportunidades tuvo una actitud abierta y positiva; pero no lo suficiente para beneficiar significativamente el trabajo del equipo.',
    },
    {
      'value': 4,
      'label': 'Good',
      'description':
          'La mayor parte del tiempo muestra apertura y actitud positiva hacia el trabajo, pero puede ser más constante.',
    },
    {
      'value': 5,
      'label': 'Excellent',
      'description':
          'Su actitud es positiva y demuestra deseos de realizar el trabajo con calidad.',
    },
  ];

  @override
  void initState() {
    super.initState();

    final source = AssessmentsSourceService(
      dio: Dio(),
      databaseBaseUrl: authController.databaseBaseUrl,
    );

    final repository = AssessmentsRepository(source: source);

    assessmentsController = Get.put(
      AssessmentsController(repository: repository),
      tag: 'submit_assessment_${widget.assessmentId}',
    );

    checkIfAlreadySubmitted();
  }

  

  void setScore(String email, String criteria, int value) {
    responses.putIfAbsent(email, () => {});
    responses[email]![criteria] = value;
    setState(() {});
  }

  int getCompletedEvaluations() {
    int count = 0;

    for (final entry in responses.entries) {
      final scores = entry.value;

      if (scores.containsKey('p') &&
          scores.containsKey('c') &&
          scores.containsKey('cm') &&
          scores.containsKey('a')) {
        count++;
      }
    }

    return count;
  }

  bool isAllCompleted() {
    return getCompletedEvaluations() == widget.peers.length;
  }

  bool isPeerCompleted(String email) {
    final scores = responses[email];

    if (scores == null) return false;

    return scores.containsKey('p') &&
        scores.containsKey('c') &&
        scores.containsKey('cm') &&
        scores.containsKey('a');
  }

  //Revisar se envio la respuesta a la evaluacion
  Future<void> checkIfAlreadySubmitted() async {
    final accessToken = authController.accessToken;
    final evaluatorEmail = authController.currentUser.value?.email;

    if (accessToken == null || evaluatorEmail == null) {
      setState(() {
        checkingSubmission = false;
      });
      return;
    }

    final result = await assessmentsController.hasStudentSubmittedAssessment(
      accessToken: accessToken,
      assessmentId: widget.assessmentId,
      evaluatorEmail: evaluatorEmail,
    );

    setState(() {
      alreadySubmitted = result;
      checkingSubmission = false;
    });
  }

  //criterios de diseno 
  Widget buildCriteriaCard({
    required String email,
    required String criteriaTitle,
    required String criteriaKey,
    required List<Map<String, dynamic>> rubricOptions,
  }) {
    final selected = responses[email]?[criteriaKey];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            criteriaTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...rubricOptions.map((option) {
            final value = option['value'] as int;
            final label = option['label'] as String;
            final description = option['description'] as String;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color:
                    selected == value ? const Color(0xFFE8F3E3) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected == value
                      ? const Color(0xFF577F49)
                      : Colors.grey.shade300,
                ),
              ),
              child: RadioListTile<int>(
                value: value,
                groupValue: selected,
                activeColor: const Color(0xFF577F49),
                title: Text(
                  '$value.0 - $label',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  description,
                  style: const TextStyle(fontSize: 13, height: 1.3),
                ),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setScore(email, criteriaKey, newValue);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
   
  // Enviar las respuestas
  Future<void> submit() async {
    final accessToken = authController.accessToken;
    final evaluatorEmail = authController.currentUser.value?.email;
    final evaluatorName = authController.currentUser.value?.name ?? '';

    if (alreadySubmitted) {
      Get.snackbar('Aviso', 'Ya enviaste esta evaluación');
      return;
    }

    if (accessToken == null || evaluatorEmail == null) {
      Get.snackbar('Error', 'Usuario no autenticado');
      return;
    }

    if (responses.isEmpty) {
      Get.snackbar('Error', 'Completa al menos una evaluación');
      return;
    }

    final List<Map<String, dynamic>> records = [];

    for (final peer in widget.peers) {
      final evaluatedEmail = peer['StudentEmail']?.toString() ?? '';
      final evaluatedName = peer['StudentName']?.toString() ?? '';

      final peerScores = responses[evaluatedEmail];

      if (peerScores == null ||
          !peerScores.containsKey('p') ||
          !peerScores.containsKey('c') ||
          !peerScores.containsKey('cm') ||
          !peerScores.containsKey('a')) {
        Get.snackbar(
          'Error',
          'Debes completar todos los criterios para $evaluatedName',
        );
        return;
      }

      records.add({
        'AssessmentId': widget.assessmentId,
        'EvaluatorEmail': evaluatorEmail,
        'EvaluatorName': evaluatorName,
        'EvaluatedEmail': evaluatedEmail,
        'EvaluatedName': evaluatedName,
        'GroupCode': widget.groupCode,
        'CourseCode': int.tryParse(widget.courseCode) ?? widget.courseCode,
        'p_score': peerScores['p'],
        'c_score': peerScores['c'],
        'cm_score': peerScores['cm'],
        'a_score': peerScores['a'],
        'CreatedAt': DateTime.now().toIso8601String(),
      });
    }

    await assessmentsController.submitAssessmentResponses(
      accessToken: accessToken,
      records: records,
    );

    if (assessmentsController.errorMessage.value.isNotEmpty) {
      Get.snackbar('Error', assessmentsController.errorMessage.value);
      return;
    }

    setState(() {
      alreadySubmitted = true;
    });

    Get.back();
    Get.snackbar('Éxito', 'Evaluación enviada correctamente');
  }

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);

    if (checkingSubmission) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (alreadySubmitted) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.assessmentName),
          backgroundColor: greenDark,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Ya respondiste esta evaluación.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assessmentName),
        backgroundColor: greenDark,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Evaluados: ${getCompletedEvaluations()} / ${widget.peers.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...widget.peers.map((peer) {
            final email = peer['StudentEmail']?.toString() ?? '';
            final name = peer['StudentName']?.toString() ?? 'Sin nombre';

            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isPeerCompleted(email))
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    buildCriteriaCard(
                      email: email,
                      criteriaTitle: 'Punctuality',
                      criteriaKey: 'p',
                      rubricOptions: punctualityRubric,
                    ),
                    buildCriteriaCard(
                      email: email,
                      criteriaTitle: 'Contributions',
                      criteriaKey: 'c',
                      rubricOptions: contributionsRubric,
                    ),
                    buildCriteriaCard(
                      email: email,
                      criteriaTitle: 'Commitment',
                      criteriaKey: 'cm',
                      rubricOptions: commitmentRubric,
                    ),
                    buildCriteriaCard(
                      email: email,
                      criteriaTitle: 'Attitude',
                      criteriaKey: 'a',
                      rubricOptions: attitudeRubric,
                    ),
                  ],
                ),
              ),
            );
          }),
          ElevatedButton(
            onPressed: isAllCompleted() ? submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: greenDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              isAllCompleted()
                  ? 'Enviar evaluación'
                  : 'Completa todas las evaluaciones',
            ),
          ),
        ],
      ),
    );
  }
}