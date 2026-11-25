import 'package:event_registration/main_form_only.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('форма показывает введённые данные в диалоге', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FormOnlyApp());

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Иванов Иван');
    await tester.enterText(fields.at(1), 'ivan@example.com');

    await tester.tap(find.text('Мне исполнилось 14 лет'));
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.text('Ж'));

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dart').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('ИИ'));
    await tester.enterText(fields.last, 'Люблю Flutter');
    await tester.pump();

    await tester.tap(find.text('Отправить'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    final dialog = find.byType(AlertDialog);
    String textOf(String q) => (tester
            .widget<Text>(find.descendant(
                of: dialog,
                matching: find.byWidgetPredicate((w) =>
                    w is Text &&
                    (w.textSpan?.toPlainText().startsWith('$q: ') ?? false))))
            .textSpan!)
        .toPlainText();

    expect(textOf('ФИО'), 'ФИО: Иванов Иван');
    expect(textOf('Мне исполнилось 14 лет'), 'Мне исполнилось 14 лет: да');
    expect(textOf('Количество котов'), 'Количество котов: 2');
    expect(textOf('Пол'), 'Пол: Ж');
    expect(textOf('Любимый язык'), 'Любимый язык: Dart');
    expect(textOf('Интересы'), 'Интересы: ИИ');
    expect(textOf('О себе'), 'О себе: Люблю Flutter');
  });

  testWidgets('пустая форма не отправляется', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FormOnlyApp());
    await tester.tap(find.text('Отправить'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Введите ФИО'), findsOneWidget);
  });
}
