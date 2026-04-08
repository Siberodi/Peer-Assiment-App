import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login.dart';
import '../controllers/authentication_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationController authenticationController = Get.find();

  late Future<List<Map<String, dynamic>>> groupsFuture;

  @override
  void initState() {
    super.initState();
    groupsFuture = authenticationController.getStudentGroupsWithPeers();
  }

  @override
  Widget build(BuildContext context) {
    final user = authenticationController.currentUser.value;
    final userName = user?.name ?? 'Usuario';

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: groupsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final groups = snapshot.data ?? [];

          return ListView(
            children: [
              Text('Hola, $userName'),

              ...groups.map((group) {
                return Text(group['GroupName'] ?? 'Sin nombre');
              }),

              /// 👇 IMAGEN SEGURA (NO ROMPE TEST)
              Image.network(
                'https://images.unsplash.com/photo-1515879218367-8466d910aaa4',
                errorBuilder: (_, __, ___) {
                  return const SizedBox(height: 100);
                },
              )
            ],
          );
        },
      ),
    );
  }
}