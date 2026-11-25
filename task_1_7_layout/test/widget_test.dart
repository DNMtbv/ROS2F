import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layout_app/main.dart';

void main() {
  testWidgets('нажатие на котика чередует текст', (tester) async {
    await tester.pumpWidget(const LayoutApp());
    expect(find.text(initialText), findsOneWidget);

    await tester.tap(find.byType(Image));
    await tester.pump();
    expect(find.text(catText), findsOneWidget);

    await tester.tap(find.byType(Image));
    await tester.pump();
    expect(find.text(initialText), findsOneWidget);
  });

  testWidgets('котик на 42 px от низа', (tester) async {
    await tester.pumpWidget(const LayoutApp());
    final pos = tester.widget<Positioned>(find.byType(Positioned));
    expect(pos.bottom, 42);
  });
}
