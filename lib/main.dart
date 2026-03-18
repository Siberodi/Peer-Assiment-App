import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/authentication_controller.dart';
import 'auth/login.dart';

void main() {
  Get.put(AuthenticationController());
  runApp(const PeervalApp());
}

class PeervalApp extends StatelessWidget {
  const PeervalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peerval',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F3F3),
      ),
      home: const LoginScreen(),
    );
  }
}