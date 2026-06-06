# Popytka UA - Документація проекту для Gemini

## 🚗 Огляд проекту
**Popytka UA** — це додаток для спільного використання поїздок (ridesharing) на базі Flutter, розроблений спеціально для українського ринку. Він з'єднує водіїв з вільними місцями та пасажирів, які подорожують в одному напрямку.

## 🛠 Технологічний стек
- **Framework:** Flutter (Android, iOS, Web, Windows)
- **State Management:** Riverpod (з використанням `riverpod_generator` та кодогенерації)
- **Navigation:** GoRouter (ShellRoute для нижньої навігації)
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Localization:** Flutter Gen (L10n) - UK (основна), RU, EN.
- **Models:** Freezed & JSON Serializable (необхідний запуск `build_runner`).
- **Maps:** `flutter_map` з інтерактивними анімаціями маршрутів (`flutter_map_animations`).
- **UI:** Custom Material 3 з підтримкою Light/Dark режимів та Cupertino-елементами.

## 📂 Структура проекту
- `lib/domain/models/`: Моделі даних (User, Ride, Booking, Chat, Transaction, Statistics).
- `lib/data/repositories/`: Firebase реалізація логіки (Auth, Ride, Booking, Chat, Wallet, Rating).
- `lib/data/providers/`: Riverpod провайдери для стану та DI.
- `lib/presentation/`:
  - `screens/`: Організовані за функціями (auth, home, profile, publish, messages, wallet, rating, admin).
  - `router/`: Конфігурація GoRouter (`app_router.dart`).
  - `theme/`: Стилізація (`app_theme.dart`, `app_colors.dart`).
- `docs/`: Детальна документація (архітектура, БД, інструкції).
- `scripts/`: Скрипти для автоматизації збірки та керування Gradle на Windows.

## ⚡ Ключові функції та поточний статус
- **Auth Flow:** Повний цикл (Phone/Google) з автоматичним створенням профілю.
- **Пошук та бронювання:** Розширений пошук з фільтрами за датою/часом.
- **Опублікувати поїздку:** Повний потік з підтримкою редагування та вибором місць на карті.
- **Messaging (Phase 7):** Чат у реальному часі між користувачами.
- **Wallet System:** Управління балансом, історія транзакцій (поповнення/виведення).
- **Statistics:** Детальна аналітика для водіїв та пасажирів (заробіток, кількість поїздок).
- **Rating System:** Можливість оцінювати поїздки та користувачів.
- **Admin Panel:** Управління користувачами та поїздками безпосередньо з додатка.
- **Стабільність:** "Anti-crash" інфраструктура в `main.dart` та **Demo Mode** (резервна робота при відсутності конфігурації Firebase).

## ⚠️ Критичні зауваження щодо розробки
- **Кодогенерація:** Завжди запускайте `dart run build_runner build --delete-conflicting-outputs` після зміни моделей або провайдерів.
- **Gradle Management:** Використовуйте `scripts/check_build.bat` для перевірки середовища (диск D:).
- **Localization:** Нові рядки додаються в `lib/l10n/app_uk.arb`. Після цього — `flutter gen-l10n`.
- **Firebase Emulators:** Пріоритет для локальної розробки.

## 🤖 Інструкції для Gemini
1.  **Дотримуйтесь Clean Architecture:** Логіка в репозиторіях, стан у провайдерах, UI в presentation.
2.  **Freezed Моделі:** Використовуйте `@freezed` для нових моделей для забезпечення immutability та зручної серіалізації.
3.  **Типізація:** Суворо дотримуйтесь типів, особливо при роботі з Firestore (правильна обробка типів LocationModel).
4.  **Стиль коду:** Використовуйте сучасний синтаксис Riverpod (`@riverpod` анотації).
5.  **Локалізація:** Жодних захардкоджених рядків в UI — тільки через `context.l10n`.
