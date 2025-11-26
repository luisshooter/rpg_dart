// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_app/presenter/personagens/personagens_view.dart';

void main() {
  testWidgets('Load PersonagensView', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PersonagensView()));
    await tester.pumpAndSettle();
    expect(find.text('Personagens'), findsOneWidget);
  });
}
