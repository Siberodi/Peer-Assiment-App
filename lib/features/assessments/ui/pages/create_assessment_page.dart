import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../controllers/authentication_controller.dart';
import '../../data/datasources/remote/assessments_source_service.dart';
import '../../data/repositories/assessments_repository.dart';
import '../viewmodels/assessments_controller.dart';

class CreateAssessmentPage extends StatefulWidget {
  final String courseCode;
  final String courseName;

  const CreateAssessmentPage({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  State<CreateAssessmentPage> createState() => _CreateAssessmentPageState();
}

class _CreateAssessmentPageState extends State<CreateAssessmentPage> {
  final AuthenticationController authController = Get.find();
  late final AssessmentsController controller;

  final TextEditingController nameController = TextEditingController();

  DateTime? startDateTime;
  DateTime? endDateTime;

  bool visibility = true;

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
      tag: 'create_assessment_${widget.courseCode}',
    );
  }

  Future<void> pickDateTime({required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        startDateTime = fullDateTime;
      } else {
        endDateTime = fullDateTime;
      }
    });
  }

  Future<void> createAssessment() async {
    final accessToken = authController.accessToken;
    final teacherEmail = authController.currentUser.value?.email;

    if (accessToken == null || teacherEmail == null) return;

    if (nameController.text.trim().isEmpty ||
        startDateTime == null ||
        endDateTime == null) {
      Get.snackbar('Error', 'Completa todos los campos');
      return;
    }

    if (endDateTime!.isBefore(startDateTime!)) {
      Get.snackbar('Error', 'La fecha final debe ser posterior a la inicial');
      return;
    }

    await controller.createAssessment(
      accessToken: accessToken,
      assessmentName: nameController.text.trim(),
      courseCode: widget.courseCode,
      courseName: widget.courseName,
      teacherEmail: teacherEmail,
      visibility: visibility,
      startAt: startDateTime!.toIso8601String(),
      endAt: endDateTime!.toIso8601String(),
      status: true,
    );

    if (controller.errorMessage.value.isNotEmpty) {
      Get.snackbar('Error', controller.errorMessage.value);
      return;
    }

    Get.back();
    Get.snackbar('Éxito', 'Evaluación creada correctamente');
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);
    const background = Color(0xFFF3F3F3);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Crear Evaluación'),
        backgroundColor: greenDark,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la evaluación',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickDateTime(isStart: true),
                    child: Text(
                      startDateTime == null
                          ? 'Inicio'
                          : startDateTime.toString(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickDateTime(isStart: false),
                    child: Text(
                      endDateTime == null
                          ? 'Fin'
                          : endDateTime.toString(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Visible para estudiantes'),
              value: visibility,
              onChanged: (val) {
                setState(() {
                  visibility = val;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createAssessment,
                child: const Text('Crear evaluación'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}