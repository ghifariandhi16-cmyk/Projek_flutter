// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_app/main.dart';

void main() {
  testWidgets('mahasiswa can save profile data', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'Ayu Pratama');
    await tester.enterText(find.byType(TextFormField).at(1), '12345678');
    await tester.enterText(find.byType(TextFormField).at(2), 'Informatika');
    await tester.ensureVisible(find.text('Simpan Data'));
    await tester.tap(find.text('Simpan Data'));
    await tester.pump();

    expect(find.text('Data Tersimpan'), findsOneWidget);
    expect(find.text('Ayu Pratama'), findsOneWidget);
    expect(find.text('NPM: 12345678'), findsOneWidget);
    expect(find.text('Jurusan: Informatika'), findsOneWidget);
  });
}
