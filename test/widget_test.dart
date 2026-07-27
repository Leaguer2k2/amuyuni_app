import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Amuyuni app renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const AmuyuniApp());

    expect(find.text('Aprende'), findsOneWidget);
    expect(find.text('Radar'), findsOneWidget);
    expect(find.text('Mi Ayllu'), findsOneWidget);
  });
}
