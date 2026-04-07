import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/Home/home.dart';

void main() {
  testWidgets('HomeScreen muestra el texto de error cuando no hay grupos', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('No tienes grupos asignados.'), findsOneWidget);
  });

  testWidgets('HomeScreen muestra el nombre del usuario en el AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.textContaining('María López'), findsOneWidget);
  });
}