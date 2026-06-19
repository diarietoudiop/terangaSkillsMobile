// Widget tests for TerangaSkills app.
import 'package:flutter_test/flutter_test.dart';
import 'package:teranga_skills/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const TerangaSkillsApp());
    expect(find.byType(TerangaSkillsApp), findsOneWidget);
  });
}
