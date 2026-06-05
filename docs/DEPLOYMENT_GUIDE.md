# ГАЙД З РОЗГОРТАННЯ - Popytka UA

## 1. НАЛАШТУВАННЯ FIREBASE PRODUCTION

### Крок 1: Створення Production проекту Firebase
1. Перейдіть у [Firebase Console](https://console.firebase.google.com/)
2. Створіть новий проект: `popytka-ua-prod`
3. Увімкніть Authentication (Google, Phone)
4. Увімкніть Firestore Database
5. Увімкніть Storage
6. Налаштуйте правила безпеки (див. нижче)

### Крок 2: Завантаження конфігурації
1. Завантажте `google-services.json` для Android
2. Завантажте `GoogleService-Info.plist` для iOS
3. Розмістіть файли у відповідних директоріях:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### Крок 3: Правила безпеки Firestore
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Користувачі можуть читати/писати свої дані
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Поїздки - авторизовані читають усі, пишуть свої
    match /rides/{rideId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == resource.data.riderId;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.riderId;
    }
    
    // Бронювання - користувачі працюють зі своїми бронюваннями
    match /bookings/{bookingId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.passengerId || 
         request.auth.uid == get(/databases/$(database)/documents/rides/$(resource.data.rideId)).data.riderId);
    }
    
    // Чати - учасники можуть читати/писати
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participantIds;
      
      match /messages/{messageId} {
        allow read, write: if request.auth != null && 
          request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participantIds;
      }
    }
  }
}
```

### Крок 4: Правила безпеки Storage
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Фото профілю
    match /users/{userId}/profile.jpg {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Фото автомобілів
    match /users/{userId}/cars/{carPhotoId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 2. ЗБІРКА РЕЛІЗУ ANDROID (Release Build)

### Крок 1: Генерація Keystore
```bash
keytool -genkey -v -keystore ~/popytka-ua-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias popytka-ua
```

### Крок 2: Налаштування підпису (Signing)
Створіть файл `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=popytka-ua
storeFile=C:/path/to/popytka-ua-key.jks
```

### Крок 3: Оновлення build.gradle
Уже налаштовано в `android/app/build.gradle`

### Крок 4: Збірка релізу
```bash
flutter build appbundle --release
flutter build apk --release
```

## 3. ЧЕК-ЛИСТ БЕЗПЕКИ

- [ ] Правила безпеки Firebase впроваджено
- [ ] API ключі захищені (немає у вихідному коді)
- [ ] Валідація користувацького введення
- [ ] Тільки HTTPS з'єднання
- [ ] Правильний потік аутентифікації
- [ ] Шифрування даних у спокої (At rest)
- [ ] Регулярні оновлення безпеки

## 4. ОПТИМІЗАЦІЯ ПРОДУКТИВНОСТІ

- [ ] Оптимізація та кешування зображень
- [ ] Оптимізація запитів до бази даних
- [ ] Впровадження Lazy Loading
- [ ] Оптимізація розміру бандла (Bundle size)
- [ ] Запобігання витокам пам'яті
- [ ] Оптимізація мережевих запитів

## 5. ПІДГОТОВКА ДО APP STORE

### Необхідні активи (Assets):
- [ ] Іконка додатка (1024x1024)
- [ ] Графіка для фічерінгу (1024x500)
- [ ] Скріншоти (різні розміри)
- [ ] Опис додатка (UK/RU/EN)
- [ ] Політика конфіденційності
- [ ] Умови використання

### Метадані:
- **Назва додатка:** Popytka UA
- **Package:** com.example.popytka_ua
- **Версія:** 1.0.0+1
- **Target SDK:** 34 (Android 14)
- **Min SDK:** 21 (Android 5.0)

## 6. ЧЕК-ЛИСТ ТЕСТУВАННЯ

- [ ] Unit тести проходять
- [ ] Інтеграційні тести проходять
- [ ] Ручне тестування на реальних пристроях
- [ ] Тестування продуктивності
- [ ] Тестування безпеки
- [ ] Тестування доступності (Accessibility)

## 7. КОМАНДИ РОЗГОРТАННЯ

```bash
# Очищення та отримання залежностей
flutter clean
flutter pub get

# Генерація коду
dart run build_runner build --delete-conflicting-outputs

# Збірка для релізу
flutter build appbundle --release

# Деплой у Firebase (якщо використовується Hosting)
firebase deploy --only hosting

# Завантаження у Play Store
# Використовуйте Google Play Console або fastlane
```

## 8. ПІСЛЯ РОЗГОРТАННЯ

- [ ] Моніторинг звітів про збої (Crash reports)
- [ ] Моніторинг метрик продуктивності
- [ ] Збір відгуків користувачів
- [ ] Налаштування аналітики
- [ ] Стратегія резервного копіювання
- [ ] Стратегія оновлень
