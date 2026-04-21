import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peer_assiment_app_1/features/auth/ui/viewmodels/authentication_controller.dart';
import 'package:peer_assiment_app_1/core/app_role.dart';
import 'package:peer_assiment_app_1/features/auth/ui/pages/login.dart';
import 'package:peer_assiment_app_1/features/auth/ui/pages/verify_email.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controllerEmail = TextEditingController();
  final controllerName = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final AuthenticationController authenticationController = Get.find();

  bool obscurePassword = true;
  AppRole? selectedRole;

  Future<void> _register() async {
    if (selectedRole == null) {
      Get.snackbar(
        'Registro',
        'Debes seleccionar si eres estudiante o docente',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
        print('UI register -> antes de signUp');
        await authenticationController.signUp(
          controllerEmail.text,
          controllerPassword.text,
          controllerName.text,
          selectedRole!,
        );
        print('UI register -> después de signUp');

      if (Get.testMode) return;

      Get.snackbar(
        'Registro',
        'Revisa tu correo para verificar la cuenta',
        snackPosition: SnackPosition.BOTTOM,
      );

        // AQUÍ EN VEZ DE IR AL HOME
      Get.to(() => VerifyEmailScreen(
          email: controllerEmail.text,
          password: controllerPassword.text,
          name: controllerName.text,
          role: selectedRole!,
        ));
      
    } catch (err) {
      Get.snackbar(
        'Registro',
        err.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerName.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const greenDark = Color(0xFF577F49);
    const greenSoft = Color(0xFFC6E0BC);
    const background = Color(0xFFF3F3F3);

    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 360,
              color: greenDark,
              child: const SafeArea(
                bottom: false,
                child: Center(
                  child: Text(
                    'Regístrate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                decoration: const BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 34),
                      const Text(
                        'Correo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        key: const Key('emailField'),
                        controller: controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu correo';
                          }
                          if (!value.contains('@')) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Nombre',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        key: const Key('nameField'),
                        controller: controllerName,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        key: const Key('passwordField'),
                        controller: controllerPassword,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }
                          final password = value.trim();
                          if (
                                password.length < 8 ||
                                !RegExp(r'[A-Z]').hasMatch(password) ||
                                !RegExp(r'[a-z]').hasMatch(password) ||
                                !RegExp(r'[0-9]').hasMatch(password) ||
                                !RegExp(r'[!@#\$_-]').hasMatch(password)
                              ) {
                              return 'La contraseña debe tener mínimo 8 caracteres, una mayúscula, una minúscula, un número y un símbolo (! @ # \$ _ -)';
                            }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Estudiante',
                                style: TextStyle(
                                  color: greenDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Checkbox(
                                value: selectedRole == AppRole.student,
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value == true ? AppRole.student : null;
                                  });
                                },
                              )
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Text(
                                'Docente',
                                style: TextStyle(
                                  color: greenDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Checkbox(
                                value: selectedRole == AppRole.teacher,
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value == true ? AppRole.teacher : null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          key: const Key('registerButton'),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            if (formKey.currentState!.validate()) {
                              await _register();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenSoft,
                            foregroundColor: greenDark,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Ya tienes cuenta? ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.off(() => const LoginScreen());
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Inicia Sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: greenDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}