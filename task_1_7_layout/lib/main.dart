import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String gitUrl =
    'https://github.com/DNMtbv/Ros2F/tree/main/task_1_7_layout';
const String smolguUrl = 'https://www.smolgu.ru';

const String initialText = 'Это моё приложение на Flutter!';
const String catText = 'Это котик';

void main() => runApp(const LayoutApp());

class LayoutApp extends StatelessWidget {
  const LayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Первое приложение на Flutter',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      body: SafeArea(
        child: Stack(
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
      ),
    );
  }
}
