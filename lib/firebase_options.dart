// Настройки Firebase-проекта ros2f-427c5
// (взяты из android/app/google-services.json).
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'Firebase настроен только для Android. Запустите приложение '
      'на Android-эмуляторе или телефоне.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZcO3G8KGDFGpfj5Ua-UjRw0vR3Fxp3XM',
    appId: '1:403296508212:android:dc06e66cf094c4f9d5ad61',
    messagingSenderId: '403296508212',
    projectId: 'ros2f-427c5',
    storageBucket: 'ros2f-427c5.firebasestorage.app',
  );
}
