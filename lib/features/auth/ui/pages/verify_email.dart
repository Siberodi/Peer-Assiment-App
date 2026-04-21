import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/home/ui/pages/home.dart';
import 'package:peer_assiment_app_1/features/home/ui/pages/professor_home.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final AppRole role;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final codeController = TextEditingController();
  final auth = Get.find<AuthenticationController>();

  bool isLoading = false;

  Future<void> verify() async {
    setState(() => isLoading = true);

    try {
      await auth.verifyEmailAndCompleteProfile(
        widget.email,
        widget.password,
        widget.name,
        widget.role,
        codeController.text,
      );

      if (Get.testMode) return;

      final user = auth.currentUser.value;

      if (user?.role == AppRole.student) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const ProfessorHomeScreen());
      }
    } catch (e) {
      Get.snackbar(
        'Verificación',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar correo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Ingresa el código que llegó a tu correo'),
            const SizedBox(height: 20),
            TextField(
              key: const Key('codeField'),
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Código',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('verifyButton'),
              onPressed: isLoading ? null : verify,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}