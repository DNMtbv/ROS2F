// Задание 1.8: форма регистрации на мероприятие.
// 12 вопросов, 10 разных виджетов ввода:
//   TextFormField, Checkbox, счётчик (IconButton), Radio, Dropdown,
//   Slider, SegmentedButton, FilterChip, Switch, DatePicker.
// Кнопка «Отправить» показывает все введённые данные в диалоге.
import 'package:flutter/material.dart';

enum Gender { male, female }

enum Format { offline, online }

const languages = ['Dart', 'Python', 'C++', 'Java', 'JavaScript', 'Go', 'C#'];
const interests = ['Мобильная разработка', 'Веб', 'ИИ', 'Игры', 'Роботы'];

String? validateEmail(String? v) {
  final s = v?.trim() ?? '';
  if (s.isEmpty) return 'Введите email';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s)) {
    return 'Некорректный email';
  }
  return null;
}

class RegistrationData {
  RegistrationData({
    required this.fullName,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.isOver14,
    required this.cats,
    required this.gender,
    required this.language,
    required this.skill,
    required this.format,
    required this.interests,
    required this.newsletter,
    required this.about,
  });

  final String fullName;
  final String email;
  final String password;
  final DateTime? birthDate;
  final bool isOver14;
  final int cats;
  final Gender gender;
  final String language;
  final int skill;
  final Format format;
  final Set<String> interests;
  final bool newsletter;
  final String about;

  /// Пары «вопрос — ответ» для информационного окна.
  List<(String, String)> get summary => [
        ('ФИО', fullName),
        ('Email', email),
        ('Дата рождения', birthDate == null ? 'не указана' : formatDate(birthDate!)),
        ('Мне исполнилось 14 лет', isOver14 ? 'да' : 'нет'),
        ('Количество котов', '$cats'),
        ('Пол', gender == Gender.male ? 'М' : 'Ж'),
        ('Любимый язык', language),
        ('Уровень программирования', '$skill из 10'),
        ('Формат участия', format == Format.offline ? 'очно' : 'онлайн'),
        ('Интересы', interests.isEmpty ? '—' : interests.join(', ')),
        ('Рассылка', newsletter ? 'подписан(а)' : 'нет'),
        ('О себе', about.isEmpty ? '—' : about),
      ];
}

String formatDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, this.onSubmit});

  /// Если задан (задание 1.9) — форма спрашивает пароль и после
  /// подтверждения создаёт аккаунт. Возвращает текст ошибки или null.
  final Future<String?> Function(RegistrationData data)? onSubmit;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();
  final _about = TextEditingController();

  DateTime? _birthDate;
  bool _isOver14 = false;
  int _cats = 0;
  Gender _gender = Gender.male;
  String? _language;
  double _skill = 5;
  Format _format = Format.offline;
  final Set<String> _interests = {};
  bool _newsletter = true;
  bool _busy = false;

  bool get _withAccount => widget.onSubmit != null;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _password2, _about]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18),
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final data = RegistrationData(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
      birthDate: _birthDate,
      isOver14: _isOver14,
      cats: _cats,
      gender: _gender,
      language: _language!,
      skill: _skill.round(),
      format: _format,
      interests: {..._interests},
      newsletter: _newsletter,
      about: _about.text.trim(),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ваши данные'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (q, a) in data.summary)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: '$q: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: a),
                  ])),
                ),
            ],
          ),
        ),
        actions: _withAccount
            ? [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Изменить'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Создать аккаунт'),
                ),
              ]
            : [
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('OK'),
                ),
              ],
      ),
    );

    if (confirmed != true || !_withAccount || !mounted) return;

    setState(() => _busy = true);
    final error = await widget.onSubmit!(data);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      // Пользователь вошёл — возвращаемся к AuthGate, он покажет главную.
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 6),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация на IT-фестиваль')),
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                // 1. ФИО — TextFormField
                _label('ФИО'),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Иванов Иван Иванович',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Введите ФИО' : null,
                ),

                // 2. Email — TextFormField
                _label('Email'),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'name@example.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateEmail,
                ),

                if (_withAccount) ...[
                  _label('Пароль'),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Минимум 6 символов',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Минимум 6 символов'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password2,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Повторите пароль',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v != _password.text ? 'Пароли не совпадают' : null,
                  ),
                ],

                // 3. Дата рождения — DatePicker
                _label('Дата рождения'),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_birthDate == null
                      ? 'Выбрать дату'
                      : formatDate(_birthDate!)),
                ),

                // 4. Возраст — Checkbox
                const SizedBox(height: 12),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _isOver14,
                  onChanged: (v) => setState(() => _isOver14 = v ?? false),
                  title: const Text('Мне исполнилось 14 лет'),
                ),

                // 5. Количество котов — счётчик
                _label('Количество котов'),
                Row(
                  children: [
                    IconButton.outlined(
                      onPressed: _cats > 0
                          ? () => setState(() => _cats--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text('$_cats',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    IconButton.outlined(
                      onPressed: _cats < 20
                          ? () => setState(() => _cats++)
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                // 6. Пол — Radio
                _label('Пол'),
                RadioGroup<Gender>(
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? _gender),
                  child: Row(
                    children: [
                      for (final (g, text) in [
                        (Gender.male, 'М'),
                        (Gender.female, 'Ж'),
                      ])
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => setState(() => _gender = g),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [Radio<Gender>(value: g), Text(text)],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // 7. Любимый язык — Dropdown
                _label('Любимый язык программирования'),
                DropdownButtonFormField<String>(
                  initialValue: _language,
                  hint: const Text('Выберите'),
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  items: [
                    for (final l in languages)
                      DropdownMenuItem(value: l, child: Text(l)),
                  ],
                  onChanged: (v) => setState(() => _language = v),
                  validator: (v) => v == null ? 'Выберите язык' : null,
                ),

                // 8. Уровень — Slider
                _label('Уровень программирования: ${_skill.round()} из 10'),
                Slider(
                  value: _skill,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '${_skill.round()}',
                  onChanged: (v) => setState(() => _skill = v),
                ),

                // 9. Формат — SegmentedButton
                _label('Формат участия'),
                SegmentedButton<Format>(
                  segments: const [
                    ButtonSegment(
                        value: Format.offline,
                        label: Text('Очно'),
                        icon: Icon(Icons.groups)),
                    ButtonSegment(
                        value: Format.online,
                        label: Text('Онлайн'),
                        icon: Icon(Icons.laptop)),
                  ],
                  selected: {_format},
                  onSelectionChanged: (s) =>
                      setState(() => _format = s.first),
                ),

                // 10. Интересы — FilterChip
                _label('Интересы'),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final i in interests)
                      FilterChip(
                        label: Text(i),
                        selected: _interests.contains(i),
                        onSelected: (on) => setState(() =>
                            on ? _interests.add(i) : _interests.remove(i)),
                      ),
                  ],
                ),

                // 11. Рассылка — Switch
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _newsletter,
                  onChanged: (v) => setState(() => _newsletter = v),
                  title: const Text('Получать новости фестиваля'),
                ),

                // 12. О себе — многострочное поле
                _label('Немного о себе'),
                TextFormField(
                  controller: _about,
                  minLines: 4,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Type here',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 28),
                Center(
                  child: FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Отправить'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
