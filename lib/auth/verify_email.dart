import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentication_controller.dart';
import '../core/app_role.dart';
import '../Home/home.dart';
import '../Home/professor_home.dart';

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
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Código',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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