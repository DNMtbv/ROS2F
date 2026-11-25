# ROS2F — приложение на Flutter (задания 1.7, 1.8, 1.9)

Одно приложение, логика как на схеме из задания 1.9:

```
Авторизация (1.9, Firebase)
 ├─ «Войти»              → Главная (1.7: лейбл, кнопки «гит» и «СмолГУ», котик)
 └─ «Зарегистрироваться» → Форма регистрации (1.8) → диалог с данными
                            → «Создать аккаунт» → Главная
```

| Экран | Файл |
|---|---|
| Авторизация | `lib/pages/login_page.dart` |
| Форма регистрации | `lib/pages/registration_page.dart` |
| Главная | `lib/pages/home_page.dart` |

**Главная (1.7):** лейбл прижат влево, кнопка «перейти на гит» по центру,
«перейти на сайт СмолГУ!» прижата вправо, котик по центру с отступом 42 px
от низа; нажатие на котика чередует текст лейбла «Это котик» / исходный.
Кнопка выхода — в правом верхнем углу.

**Форма регистрации (1.8):** 12 вопросов, 10 разных виджетов
(TextFormField, DatePicker, Checkbox, счётчик, Radio, Dropdown, Slider,
SegmentedButton, FilterChip, Switch). «Отправить» показывает все данные
в диалоговом окне.

**Авторизация (1.9):** `signInWithEmailAndPassword` /
`createUserWithEmailAndPassword` через Firebase Auth.

## Настройка Firebase (один раз)

1. Создайте проект на https://console.firebase.google.com.
2. **Authentication → Sign-in method → Email/Password → Enable.**
3. Установите CLI:
   ```
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   firebase login
   ```
4. В корне репозитория выполните `flutterfire configure` — команда заменит
   заглушку `lib/firebase_options.dart` настоящими настройками.
5. `flutter pub get` → `flutter run` (или `flutter run -d chrome`).

Пока Firebase не настроен, приложение показывает экран с подсказкой.
