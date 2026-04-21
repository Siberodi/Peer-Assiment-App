import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/features/assessments/data/datasources/remote/assessments_source_service.dart';
import 'package:peer_assiment_app_1/features/assessments/data/repositories/assessments_repository.dart';
import 'package:peer_assiment_app_1/features/assessments/ui/viewmodels/assessments_controller.dart';

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

  static const Color greenDark = Color(0xFF517A46);
  static const Color greenLight = Color(0xFFCAEDC0);
  static const Color white = Colors.white;
  static const Color background = Color(0xFFF8FBF7);

  @override
  void initState() {
    super.initState();

    final source = AssessmentsSourceService(
      dioClient: Dio(),
      databaseBaseUrl: authController.databaseBaseUrl,
      authController: authController,
    );

    final repository = AssessmentsRepository(source: source);

    controller = Get.put(
      AssessmentsController(repository: repository),
      tag: 'create_assessment_${widget.courseCode}',
    );
  }

  String formatDateTime(DateTime? value) {
    if (value == null) return '';
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month/$year - $hour:$minute';
  }

  Future<void> pickDateTime({required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: greenDark,
              onPrimary: white,
              surface: white,
              onSurface: greenDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: greenDark,
              onPrimary: white,
              surface: white,
              onSurface: greenDark,
            ),
          ),
          child: child!,
        );
      },
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
      Get.snackbar(
        'Error',
        'Completa todos los campos',
        backgroundColor: white,
        colorText: greenDark,
      );
      return;
    }

    if (endDateTime!.isBefore(startDateTime!)) {
      Get.snackbar(
        'Error',
        'La fecha final debe ser posterior a la inicial',
        backgroundColor: white,
        colorText: greenDark,
      );
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
      Get.snackbar(
        'Error',
        controller.errorMessage.value,
        backgroundColor: white,
        colorText: greenDark,
      );
      return;
    }

    Get.back();
    Get.snackbar(
      'Éxito',
      'Evaluación creada correctamente',
      backgroundColor: white,
      colorText: greenDark,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [greenLight, greenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: white,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Crear Evaluación',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: greenLight, width: 1.4),
      ),
      child: child,
    );
  }

  Widget buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: greenDark,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildTextField() {
    return TextField(
      controller: nameController,
      style: const TextStyle(
        color: greenDark,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Escribe el nombre de la evaluación',
        hintStyle: TextStyle(
          color: greenDark.withValues(alpha: 0.55),
          fontSize: 15,
        ),
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: greenLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: greenDark,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget buildDateButton({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: greenLight.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: greenLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: greenDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value.isEmpty ? 'Seleccionar' : value,
                style: TextStyle(
                  color: value.isEmpty
                      ? greenDark.withValues(alpha: 0.65)
                      : greenDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVisibilityTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: greenLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greenLight),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Visible para estudiantes',
              style: TextStyle(
                color: greenDark,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CupertinoSwitch(
            value: visibility,
            activeTrackColor: greenDark,
            inactiveTrackColor: greenLight,
            onChanged: (val) {
              setState(() {
                visibility = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: createAssessment,
        style: ElevatedButton.styleFrom(
          backgroundColor: greenDark,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'Crear evaluación',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildFieldLabel('Nombre de la evaluación'),
                        buildTextField(),
                        const SizedBox(height: 20),
                        buildFieldLabel('Fechas'),
                        Row(
                          children: [
                            buildDateButton(
                              title: 'Inicio',
                              value: formatDateTime(startDateTime),
                              onTap: () => pickDateTime(isStart: true),
                            ),
                            const SizedBox(width: 12),
                            buildDateButton(
                              title: 'Fin',
                              value: formatDateTime(endDateTime),
                              onTap: () => pickDateTime(isStart: false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildFieldLabel('Visibilidad'),
                        buildVisibilityTile(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildCreateButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}