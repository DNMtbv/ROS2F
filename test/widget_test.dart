import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ros2f/pages/home_page.dart';
import 'package:ros2f/pages/registration_page.dart';

void main() {
  group('Главная (1.7)', () {
    testWidgets('нажатие на котика чередует текст', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(find.text(initialText), findsOneWidget);

      await tester.tap(find.byType(Image));
      await tester.pump();
      expect(find.text(catText), findsOneWidget);

      await tester.tap(find.byType(Image));
      await tester.pump();
      expect(find.text(initialText), findsOneWidget);
    });

    testWidgets('котик на 42 px от низа', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      final pos = tester.widget<Positioned>(find.byType(Positioned));
      expect(pos.bottom, 42);
    });

    testWidgets('кнопка выхода вызывает onSignOut', (tester) async {
      var signedOut = false;
      await tester.pumpWidget(MaterialApp(
        home: HomePage(onSignOut: () => signedOut = true),
      ));
      await tester.tap(find.byIcon(Icons.logout));
      expect(signedOut, isTrue);
    });
  });

  group('Форма регистрации (1.8)', () {
    Future<void> pumpForm(WidgetTester tester,
        {Future<String?> Function(RegistrationData)? onSubmit}) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(home: RegistrationPage(onSubmit: onSubmit)),
      );
    }

    String dialogLine(WidgetTester tester, String q) => tester
        .widget<Text>(find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byWidgetPredicate((w) =>
                w is Text &&
                (w.textSpan?.toPlainText().startsWith('$q: ') ?? false))))
        .textSpan!
        .toPlainText();

    testWidgets('показывает введённые данные и передаёт их в onSubmit',
        (tester) async {
      RegistrationData? submitted;
      await pumpForm(tester, onSubmit: (d) async {
        submitted = d;
        return null;
      });

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Иванов Иван');
      await tester.enterText(fields.at(1), 'ivan@example.com');
      await tester.enterText(fields.at(2), 'secret1');
      await tester.enterText(fields.at(3), 'secret1');

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

      expect(dialogLine(tester, 'ФИО'), 'ФИО: Иванов Иван');
      expect(dialogLine(tester, 'Мне исполнилось 14 лет'),
          'Мне исполнилось 14 лет: да');
      expect(dialogLine(tester, 'Количество котов'), 'Количество котов: 2');
      expect(dialogLine(tester, 'Пол'), 'Пол: Ж');
      expect(dialogLine(tester, 'Любимый язык'), 'Любимый язык: Dart');
      expect(dialogLine(tester, 'Интересы'), 'Интересы: ИИ');
      expect(dialogLine(tester, 'О себе'), 'О себе: Люблю Flutter');

      await tester.tap(find.text('Создать аккаунт'));
      await tester.pumpAndSettle();
      expect(submitted?.email, 'ivan@example.com');
      expect(submitted?.password, 'secret1');
    });

    testWidgets('пустая форма не отправляется', (tester) async {
      await pumpForm(tester, onSubmit: (_) async => null);
      await tester.tap(find.text('Отправить'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Введите ФИО'), findsOneWidget);
    });
  });
}
