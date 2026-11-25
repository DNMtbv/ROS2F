# Задания 1.8 (форма регистрации) и 1.9 (авторизация + Firebase)

## 1.8 — форма регистрации (без Firebase)

```
flutter run -t lib/main_form_only.dart
```

Форма «Регистрация на IT-фестиваль» содержит 12 вопросов и 10 разных виджетов:
TextFormField, DatePicker, Checkbox, счётчик (IconButton), Radio, Dropdown,
Slider, SegmentedButton, FilterChip, Switch.
Кнопка «Отправить» показывает все введённые данные в диалоговом окне.

## 1.9 — авторизация через Firebase

Экран «Авторизация» (email + пароль):
* «Войти» → `signInWithEmailAndPassword` → «Главная»;
* «Зарегистрироваться» → форма из 1.8 (с полями пароля) → диалог с данными →
  «Создать аккаунт» → `createUserWithEmailAndPassword` → «Главная».

На главной есть кнопка выхода (`signOut`).

### Настройка Firebase (один раз)

1. Создайте проект на https://console.firebase.google.com.
2. **Authentication → Sign-in method → Email/Password → Enable.**
3. Установите CLI:
   ```
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   ```
4. В папке проекта:
   ```
   flutterfire configure
   ```
   Команда перезапишет заглушку `lib/firebase_options.dart` и подключит Android.
5. Запуск: `flutter run` (или `flutter run -d chrome`).

Пока Firebase не настроен, приложение показывает экран с подсказкой вместо падения.
