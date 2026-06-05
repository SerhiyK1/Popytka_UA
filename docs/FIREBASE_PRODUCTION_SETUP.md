# НАЛАШТУВАННЯ FIREBASE PRODUCTION - Popytka UA

## 🔥 КРОК 1: СТВОРЕННЯ PRODUCTION ПРОЕКТУ

### 1.1 Налаштування Firebase Console
1. Перейдіть у [Firebase Console](https://console.firebase.google.com/)
2. Натисніть "Створити проект" (Create a project)
3. **Назва проекту:** `Popytka UA Production`
4. **Project ID:** `popytka-ua-prod` (має бути унікальним)
5. Увімкнути Google Analytics: **ТАК**
6. Оберіть обліковий запис Analytics: **Створити новий обліковий запис**
7. **Назва облікового запису Analytics:** `Popytka UA Analytics`
8. **Країна:** Україна
9. Натисніть "Створити проект"

### 1.2 Конфігурація проекту
```bash
# Оновіть .firebaserc для кількох середовищ
{
  "projects": {
    "default": "popytka-ua",
    "development": "popytka-ua",
    "production": "popytka-ua-prod"
  }
}
```

## 🔥 КРОК 2: УВІМКНЕННЯ СЕРВІСІВ

### 2.1 Authentication
1. Перейдіть до **Authentication** → **Sign-in method**
2. Увімкніть провайдера **Google**
   - Додайте свій виробничий домен
   - Завантажте оновлені файли конфігурації
3. Увімкніть провайдера **Phone** (на майбутнє)
   - Налаштуйте аутентифікацію за номером телефону
4. **Settings** → **Authorized domains**
   - Додайте свій виробничий домен
   - Додайте `popytka-ua-prod.web.app`

### 2.2 Firestore Database
1. Перейдіть до **Firestore Database**
2. Натисніть **Create database**
3. **Security rules:** Почніть у **production mode**
4. **Location:** `europe-west3` (Франкфурт - найближче до України)
5. Натисніть **Done**

### 2.3 Storage
1. Перейдіть до **Storage**
2. Натисніть **Get started**
3. **Security rules:** Почніть у **production mode**
4. **Location:** `europe-west3` (Франкфурт)
5. Натисніть **Done**

### 2.4 Реєстрація додатка
1. Перейдіть до **Project settings** → **General**
2. Натисніть **Add app** → **Android**
3. **Package name:** `com.example.popytka_ua`
4. **Псевдонім додатка:** `Popytka UA Android`
5. **SHA-1:** Згенеруйте зі свого keystore (див. нижче)
6. Завантажте `google-services.json`
7. Розмістіть у `android/app/google-services.json`

## 🔑 КРОК 3: ГЕНЕРАЦІЯ SHA-1 СЕРТИФІКАТА

### 3.1 Створення Production Keystore
```bash
# Генерувати виробничий keystore
keytool -genkey -v -keystore popytka-ua-prod.jks -keyalg RSA -keysize 2048 -validity 10000 -alias popytka-ua-prod

# Введіть дані:
# First and last name: Popytka UA
# Organizational unit: Development
# Organization: Popytka UA
# City: Kyiv
# State: Ukraine
# Country code: UA
```

### 3.2 Отримання SHA-1
```bash
# Отримати SHA-1 з keystore
keytool -list -v -keystore popytka-ua-prod.jks -alias popytka-ua-prod

# Скопіюйте SHA-1 відбиток і додайте у Firebase
```

### 3.3 Оновлення key.properties
```properties
# android/key.properties (PRODUCTION)
storePassword=YOUR_PRODUCTION_STORE_PASSWORD
keyPassword=YOUR_PRODUCTION_KEY_PASSWORD
keyAlias=popytka-ua-prod
storeFile=../popytka-ua-prod.jks
```

## 🛡️ КРОК 4: РОЗГОРТАННЯ ПРАВИЛ БЕЗПЕКИ

### 4.1 Правила Firestore
Створіть `firestore.rules`:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Колекція Users
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null; // Дозволити читання інших користувачів для інформації про поїздку
    }
    
    // Колекція Rides
    match /rides/{rideId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.auth.uid == resource.data.riderId;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.riderId;
    }
    
    // Колекція Bookings
    match /bookings/{bookingId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.passengerId || 
         request.auth.uid == get(/databases/$(database)/documents/rides/$(resource.data.rideId)).data.riderId);
    }
    
    // Колекція Chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participantIds;
      
      // Підколекція Messages
      match /messages/{messageId} {
        allow read, write: if request.auth != null && 
          request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participantIds;
      }
    }
    
    // Розташування водіїв (для відстеження в реальному часі)
    match /driver_locations/{driverId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == driverId;
    }
  }
}
```

### 4.2 Правила Storage
Створіть `storage.rules`:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Фото профілю користувачів
    match /users/{userId}/profile/{fileName} {
      allow read: if true; // Публічне читання фото профілю
      allow write: if request.auth != null && 
        request.auth.uid == userId &&
        request.resource.size < 5 * 1024 * 1024 && // ліміт 5MB
        request.resource.contentType.matches('image/.*');
    }
    
    // Фото автомобілів
    match /users/{userId}/cars/{fileName} {
      allow read: if true; // Публічне читання фото автомобілів
      allow write: if request.auth != null && 
        request.auth.uid == userId &&
        request.resource.size < 10 * 1024 * 1024 && // ліміт 10MB
        request.resource.contentType.matches('image/.*');
    }
  }
}
```

### 4.3 Деплой правил
```bash
# Деплой на production
firebase use production
firebase deploy --only firestore:rules
firebase deploy --only storage
```

## 💳 КРОК 5: НАЛАШТУВАННЯ ТАРИФІКАЦІЇ (BILLING)

### 5.1 Перехід на Blaze Plan
1. Перейдіть до **Project settings** → **Usage and billing**
2. Натисніть **Modify plan**
3. Оберіть **Blaze (Pay as you go)**
4. Додайте спосіб оплати
5. Налаштуйте сповіщення про бюджет:
   - Щоденно: $10
   - Щомісяця: $100

### 5.2 Квоти та ліміти
Встановіть розумні ліміти:
- **Читання Firestore:** 50K/день
- **Запис Firestore:** 20K/день
- **Завантаження Storage:** 1GB/день
- **Authentication:** 10K/місяць

## 📊 КРОК 6: НАЛАШТУВАННЯ МОНІТОРИНГУ

### 6.1 Увімкнення сервісів
1. **Crashlytics** - звіти про збої
2. **Performance Monitoring** - продуктивність додатка
3. **Analytics** - поведінка користувачів
4. **Remote Config** - прапорці функцій (Feature flags)

### 6.2 Конфігурація сповіщень
Налаштуйте сповіщення для:
- Високих показників помилок
- Погіршення продуктивності
- Незвичайних сплесків використання
- Інцидентів безпеки

## 🔧 КРОК 7: КОНФІГУРАЦІЯ СЕРЕДОВИЩА

### 7.1 Оновлення конфігурації Firebase
```dart
// lib/firebase_options_prod.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'popytka-ua-prod',
    authDomain: 'popytka-ua-prod.firebaseapp.com',
    storageBucket: 'popytka-ua-prod.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'popytka-ua-prod',
    storageBucket: 'popytka-ua-prod.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'popytka-ua-prod',
    storageBucket: 'popytka-ua-prod.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.popytka_ua',
  );
}
```

## ✅ PRODUCTION ЧЕК-ЛИСТ

- [ ] Проект Firebase створено
- [ ] Authentication налаштовано
- [ ] База даних Firestore створена
- [ ] Storage bucket створено
- [ ] Додаток Android зареєстровано
- [ ] SHA-1 сертифікат додано
- [ ] Правила безпеки розгорнуто
- [ ] Тарифікація (Billing) налаштована
- [ ] Моніторинг увімкнено
- [ ] Виробничий keystore створено
- [ ] Змінні оточення встановлені

## 🚀 КОМАНДИ РОЗГОРТАННЯ

```bash
# Перейти на production
firebase use production

# Розгорнути все
firebase deploy

# Зібрати production APK
flutter build apk --release --dart-define=ENVIRONMENT=production

# Зібрати production App Bundle
flutter build appbundle --release --dart-define=ENVIRONMENT=production
```

## 📞 КОНТАКТИ ПІДТРИМКИ

- **Firebase Support:** https://firebase.google.com/support
- **Google Play Console:** https://support.google.com/googleplay
- **Екстрений контакт:** [Ваш екстрений контакт]
