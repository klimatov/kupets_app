import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kupets_app/core/theme/app_theme.dart';

void main() {
  testWidgets('приложение отображает название бара', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(body: Text('Купец&Ко')),
      ),
    );
    expect(find.text('Купец&Ко'), findsOneWidget);
  });
}
