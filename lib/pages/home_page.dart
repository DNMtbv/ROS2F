// Главная (задание 1.7 «Компоновка»):
// лейбл слева, кнопка «гит» по центру, кнопка «СмолГУ» справа,
// котик по центру с отступом 42 px от низа; нажатие меняет текст лейбла.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String gitUrl = 'https://github.com/DNMtbv/ROS2F';
const String smolguUrl = 'https://www.smolgu.ru';

const String initialText = 'Это моё приложение на Flutter!';
const String catText = 'Это котик';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.onSignOut});

  /// Выход из аккаунта (передаётся из AuthGate).
  final VoidCallback? onSignOut;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isCat = false;

  Future<void> _open(String url) async {
    final ok = await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          if (widget.onSignOut != null)
            IconButton(
              tooltip: 'Выйти',
              icon: const Icon(Icons.logout),
              onPressed: widget.onSignOut,
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Лейбл, прижатый к левому краю.
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(_isCat ? catText : initialText),
                ),
              ),
              const SizedBox(height: 24),
              // Кнопка по центру — гит проекта.
              Center(
                child: ElevatedButton(
                  onPressed: () => _open(gitUrl),
                  child: const Text('перейти на гит'),
                ),
              ),
              const SizedBox(height: 16),
              // Кнопка, прижатая к правому краю — сайт СмолГУ.
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => _open(smolguUrl),
                    child: const Text('перейти на сайт СмолГУ!'),
                  ),
                ),
              ),
            ],
          ),
          // Котик: по центру по горизонтали, отступ от низа ровно 42 px.
          Positioned(
            left: 0,
            right: 0,
            bottom: 42,
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => _isCat = !_isCat),
                child: Image.asset(
                  'assets/cat.jpg',
                  width: 300,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
