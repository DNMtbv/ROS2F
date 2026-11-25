// ЗАГЛУШКА. Этот файл будет перезаписан командой:
//   flutterfire configure
// (см. README.md). До этого приложение покажет экран с подсказкой.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase ещё не настроен. Выполните `flutterfire configure` '
      'в папке проекта — он создаст настоящий lib/firebase_options.dart.',
    );
  }
}
