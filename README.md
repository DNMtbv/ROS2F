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

## Firebase

Приложение подключено к Firebase-проекту `ros2f-427c5` (Android):
настройки лежат в `lib/firebase_options.dart` и `android/app/google-services.json`.
В консоли Firebase должен быть включён вход
**Authentication → Sign-in method → Email/Password**.

## Запуск

```
flutter pub get
flutter run        # на Android-эмуляторе или телефоне
```

Firebase настроен только для Android; в браузере и на Windows
приложение покажет экран с подсказкой.
