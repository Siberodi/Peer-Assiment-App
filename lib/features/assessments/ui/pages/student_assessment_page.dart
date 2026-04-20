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

  static const Color greenDark = Color(0xFF577F49);
  static const Color greenSoft = Color(0xFFB9DDAF);
  static const Color pageBg = Color(0xFFF4F4F4);
  static const Color blueGreyText = Color(0xFF5E738B);

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
    dioClient: Dio(),
    databaseBaseUrl: authController.databaseBaseUrl,
    authController: authController,
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

  String getCriteriaLabel(String key) {
    switch (key) {
      case 'cm':
        return 'Compromiso';
      case 'p':
        return 'Puntualidad';
      case 'c':
        return 'Calidad de Trabajo';
      case 'a':
        return 'Convivencia';
      default:
        return key;
    }
  }

  List<Map<String, dynamic>> getRubricByKey(String key) {
    switch (key) {
      case 'cm':
        return commitmentRubric;
      case 'p':
        return punctualityRubric;
      case 'c':
        return contributionsRubric;
      case 'a':
        return attitudeRubric;
      default:
        return [];
    }
  }

  Color getScoreColor(int value) {
    switch (value) {
      case 2:
        return const Color(0xFFFF4D00);
      case 3:
        return const Color(0xFFE0B000);
      case 4:
        return const Color(0xFF58A5F0);
      case 5:
        return const Color(0xFF5A854A);
      default:
        return Colors.grey;
    }
  }

  Future<void> openPeerEvaluation(int index) async {
    if (index < 0 || index >= widget.peers.length) return;

    final peer = widget.peers[index];
    final email = peer['StudentEmail']?.toString() ?? '';
    final name = peer['StudentName']?.toString() ?? 'Sin nombre';

    final result = await Navigator.push<_EvaluationAction>(
      context,
      MaterialPageRoute(
        builder: (_) => _PeerEvaluationDetailPage(
          assessmentName: widget.assessmentName,
          groupCode: widget.groupCode,
          peerName: name,
          email: email,
          currentIndex: index,
          totalStudents: widget.peers.length,
          responses: Map<String, int>.from(responses[email] ?? {}),
          onChanged: (criteriaKey, value) {
            setScore(email, criteriaKey, value);
          },
          getCriteriaLabel: getCriteriaLabel,
          getRubricByKey: getRubricByKey,
          getScoreColor: getScoreColor,
        ),
      ),
    );

    if (!mounted) return;

    if (result == _EvaluationAction.next) {
      if (index + 1 < widget.peers.length) {
        Future.microtask(() => openPeerEvaluation(index + 1));
      }
    } else if (result == _EvaluationAction.submit) {
      submit();
    }
  }

  Widget buildHeader() {
  return Container(
  width: double.infinity,
  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF8ED973), Color(0xFF4F7E43)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: SafeArea(
    bottom: false,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(height: 10),
        Text(
          widget.assessmentName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
      ],
    ),
  ),
);
}
  Widget buildAssessmentListCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E1EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: greenDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.groupCode,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Evaluación activa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: greenDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Evaluados: ${getCompletedEvaluations()} / ${widget.peers.length}',
            style: const TextStyle(
              fontSize: 16,
              color: blueGreyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(widget.peers.length, (index) {
            final peer = widget.peers[index];
            final email = peer['StudentEmail']?.toString() ?? '';
            final name = peer['StudentName']?.toString() ?? 'Sin nombre';
            final completed = isPeerCompleted(email);

            return GestureDetector(
              onTap: () => openPeerEvaluation(index),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7E6BE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: greenDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '4 ítems',
                            style: TextStyle(
                              fontSize: 15,
                              color: blueGreyText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      completed ? Icons.check_circle : Icons.chevron_right,
                      color: completed ? greenDark : blueGreyText,
                      size: 24,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (checkingSubmission) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (alreadySubmitted) {
      return Scaffold(
        backgroundColor: pageBg,
        body: Column(
          children: [
            buildHeader(),
            const Expanded(
              child: Center(
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
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: buildAssessmentListCard(),
            ),
          ),
        ],
      ),
    );
  }
}

enum _EvaluationAction { next, submit }

class _PeerEvaluationDetailPage extends StatefulWidget {
  final String assessmentName;
  final String groupCode;
  final String peerName;
  final String email;
  final int currentIndex;
  final int totalStudents;
  final Map<String, int> responses;
  final Function(String criteriaKey, int value) onChanged;
  final String Function(String key) getCriteriaLabel;
  final List<Map<String, dynamic>> Function(String key) getRubricByKey;
  final Color Function(int value) getScoreColor;

  const _PeerEvaluationDetailPage({
    required this.assessmentName,
    required this.groupCode,
    required this.peerName,
    required this.email,
    required this.currentIndex,
    required this.totalStudents,
    required this.responses,
    required this.onChanged,
    required this.getCriteriaLabel,
    required this.getRubricByKey,
    required this.getScoreColor,
  });

  @override
  State<_PeerEvaluationDetailPage> createState() =>
      _PeerEvaluationDetailPageState();
}

class _PeerEvaluationDetailPageState extends State<_PeerEvaluationDetailPage> {
  static const Color greenDark = Color(0xFF577F49);
  static const Color greenSoft = Color(0xFFB9DDAF);
  static const Color pageBg = Color(0xFFF4F4F4);
  static const Color blueGreyText = Color(0xFF5E738B);

  late Map<String, int> localResponses;

  @override
  void initState() {
    super.initState();
    localResponses = Map<String, int>.from(widget.responses);
  }

  bool get isLastStudent => widget.currentIndex == widget.totalStudents - 1;

  bool get isCompleted {
    return localResponses.containsKey('cm') &&
        localResponses.containsKey('p') &&
        localResponses.containsKey('c') &&
        localResponses.containsKey('a');
  }

  void selectScore(String criteriaKey, int value) {
    setState(() {
      localResponses[criteriaKey] = value;
    });
    widget.onChanged(criteriaKey, value);
  }

  Widget buildScoreButton({
    required int value,
    required bool selected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? greenDark : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget buildCriteriaCard(String criteriaKey) {
    final title = widget.getCriteriaLabel(criteriaKey);
    final selected = localResponses[criteriaKey];
    final options = widget.getRubricByKey(criteriaKey);

    String? description;
    if (selected != null) {
      final current = options.firstWhere(
        (e) => e['value'] == selected,
        orElse: () => <String, dynamic>{},
      );
      description = current['description'] as String?;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: greenSoft, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: greenDark,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options.map((option) {
              final value = option['value'] as int;
              return buildScoreButton(
                value: value,
                color: widget.getScoreColor(value),
                selected: selected == value,
                onTap: () => selectScore(criteriaKey, value),
              );
            }).toList(),
          ),
          if (description != null) ...[
            const SizedBox(height: 22),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final criteriaOrder = ['cm', 'p', 'c', 'a'];

return Scaffold(
  backgroundColor: pageBg,
    appBar: PreferredSize(
    preferredSize: const Size.fromHeight(170),
    child: AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8ED973), Color(0xFF4F7E43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  iconSize: 28,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.45),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    widget.assessmentName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
  body: SingleChildScrollView(
    child: Container(
      margin: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E1EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: greenDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.groupCode,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            widget.peerName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: greenDark,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Compromiso   •   Puntualidad',
            style: TextStyle(
              fontSize: 15,
              color: blueGreyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Calidad de Trabajo   •   Convivencia',
            style: TextStyle(
              fontSize: 15,
              color: blueGreyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Estudiante ${widget.currentIndex + 1} de ${widget.totalStudents}',
            style: const TextStyle(
              fontSize: 14,
              color: blueGreyText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          ...criteriaOrder.map(buildCriteriaCard),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isCompleted
                  ? () {
                      Navigator.pop(
                        context,
                        isLastStudent
                            ? _EvaluationAction.submit
                            : _EvaluationAction.next,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: greenSoft,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isLastStudent
                    ? 'ENVIAR EVALUACIÓN'
                    : 'GUARDAR RESPUESTA',
                style: TextStyle(
                  color: isCompleted ? greenDark : Colors.grey.shade600,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
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
}