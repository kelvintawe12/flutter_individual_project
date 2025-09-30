import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_individual_project/main.dart';

void main() {
  testWidgets('App builds without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(StudyPlannerApp());
    expect(find.byType(StudyPlannerApp), findsOneWidget);
  });
}
