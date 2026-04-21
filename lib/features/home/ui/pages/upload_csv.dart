import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';

class UploadCsvScreen extends StatelessWidget {
  const UploadCsvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController auth = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subir CSV'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await auth.uploadCsvAndCreateGroups();

              Get.snackbar(
                'CSV',
                'Grupos y estudiantes cargados correctamente',
                snackPosition: SnackPosition.BOTTOM,
              );
            } catch (e) {
              Get.snackbar(
                'Error',
                e.toString().replaceFirst('Exception: ', ''),
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Seleccionar archivo CSV'),
        ),
      ),
    );
  }
}