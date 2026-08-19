import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_savdo/main.dart';

void main() {
  testWidgets('TopSavdoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TopSavdoApp(),
      ),
    );
    expect(find.byType(TopSavdoApp), findsOneWidget);
  });
}
