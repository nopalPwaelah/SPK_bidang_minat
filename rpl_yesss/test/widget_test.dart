import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_yesss/main.dart';

void main() {
  testWidgets('Login screen tampil', (WidgetTester tester) async {

    // Build app
    await tester.pumpWidget(MyApp());

    // Cek apakah ada text "Login"
    expect(find.text("Login"), findsOneWidget);

    // Cek field email
    expect(find.byType(TextField), findsNWidgets(2));

    // Cek tombol login
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}