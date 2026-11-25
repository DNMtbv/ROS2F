// Задание 1.8: только форма регистрации, без Firebase.
// Запуск: flutter run -t lib/main_form_only.dart
import 'package:flutter/material.dart';

import 'pages/registration_page.dart';

void main() => runApp(const FormOnlyApp());

class FormOnlyApp extends StatelessWidget {
  const FormOnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Форма регистрации',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const RegistrationPage(),
    );
  }
}
