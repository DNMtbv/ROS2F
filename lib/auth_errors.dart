import 'package:firebase_auth/firebase_auth.dart';

/// Переводит коды ошибок FirebaseAuth на русский.
String authErrorText(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Некорректный email.';
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Неверный email или пароль.';
    case 'user-disabled':
      return 'Аккаунт заблокирован.';
    case 'email-already-in-use':
      return 'Этот email уже зарегистрирован.';
    case 'weak-password':
      return 'Слишком простой пароль (минимум 6 символов).';
    case 'too-many-requests':
      return 'Слишком много попыток. Попробуйте позже.';
    case 'network-request-failed':
      return 'Нет подключения к интернету.';
    case 'operation-not-allowed':
      return 'Вход по email/паролю не включён в консоли Firebase.';
    default:
      return e.message ?? 'Ошибка: ${e.code}';
  }
}
