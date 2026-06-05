# ВИРІШЕННЯ ПРОБЛЕМ ЗБІРКИ (BUILD TROUBLESHOOTING) - Popytka UA

## 🚨 ПРОБЛЕМА 1: Недостатньо місця на диску

### Симптоми:
```
FileSystemException - Недостатньо місця на диску
Jetifier failed to transform
BUILD FAILED in 10m 26s
```

## 🚨 ПРОБЛЕМА 2: Пошкоджений Gradle кеш

### Симптоми:
```
Could not read workspace metadata from C:\Users\...\gradle\caches\...\metadata.bin
Multiple build operations failed
Error resolving plugin [id: 'dev.flutter.flutter-plugin-loader']
BUILD FAILED in 2m 30s
```

### Причини:
1. **Gradle кеш переповнений** (~5-10 GB)
2. **Flutter build кеш великий** (~1-2 GB)
3. **Тимчасові файли Android Studio** (~2-5 GB)
4. **Системний диск C: заповнений**

## 🛠️ РІШЕННЯ

### Для проблеми з місцем на диску:

#### Рішення 1: Автоматичне очищення
```bash
scripts\fix_build_space.bat
```

### Для пошкодженого Gradle кешу:

#### Рішення 1: Екстрене очищення
```bash
scripts\emergency_gradle_fix.bat
```

#### Рішення 2: Мінімальна збірка
```bash
scripts\build_minimal.bat
```

### Рішення 2: Ручне очищення
```bash
# Очистити Flutter
flutter clean

# Очистити Gradle
cd android
gradlew clean
cd ..

# Очистити Gradle кеш (ОБЕРЕЖНО!)
rmdir /s /q "%USERPROFILE%\.gradle\caches"

# Перезібрати
flutter pub get
flutter build apk --release
```

### Рішення 3: Збірка з обмеженнями
```bash
scripts\build_release_safe.bat
```

## 💾 ВИЗВОЛЕННЯ МІСЦЯ

### Тимчасові файли:
- `%TEMP%` - тимчасові файли Windows
- `%USERPROFILE%\.gradle\caches` - Gradle кеш (5-10 GB)
- `%USERPROFILE%\.android\build-cache` - Android build кеш
- `build\` - локальний build кеш проекту

### Команди очищення:
```bash
# Очистити тимчасові файли
del /q /s %TEMP%\*

# Очистити Android кеш
rmdir /s /q "%USERPROFILE%\.android\build-cache"

# Очистити Flutter кеш
flutter clean
```

## ⚡ ОПТИМІЗАЦІЯ ЗБІРКИ

### 1. Зменшити пам'ять Gradle
У `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2G -XX:MaxMetaspaceSize=512m
```

### 2. Зібрати тільки ARM64
```bash
flutter build apk --release --split-per-abi --target-platform android-arm64
```

### 3. Вимкнути паралельну збірку
```bash
flutter build apk --release --no-tree-shake-icons
```

## 🎯 АЛЬТЕРНАТИВНІ ПІДХОДИ

### Збірка по частинах:
1. **Спочатку ARM64:** `--target-platform android-arm64`
2. **Потім ARM32:** `--target-platform android-arm`
3. **Потім x86_64:** `--target-platform android-x64`

### Використання AAB замість APK:
```bash
flutter build appbundle --release
```
AAB файли менші та потребують менше місця для збірки.

## 🔍 ДІАГНОСТИКА

### Перевірити місце на диску:
```bash
dir /-c C:\
```

### Розмір Gradle кешу:
```bash
dir /s "%USERPROFILE%\.gradle\caches"
```

### Розмір проекту:
```bash
dir /s build\
```

## 📱 ТЕСТУВАННЯ ЧАСТКОВИХ ЗБІРОК

### ARM64 APK (сучасні пристрої):
```bash
adb install build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
```

### Перевірка архітектури пристрою:
```bash
adb shell getprop ro.product.cpu.abi
```

## 🚀 ПІСЛЯ ВИРІШЕННЯ ПРОБЛЕМИ

1. **Протестувати APK на пристрої**
2. **Зібрати AAB для Play Store**
3. **Налаштувати автоматичне очищення**
4. **Моніторити місце на диску**

## 💾 ПОСТІЙНЕ РІШЕННЯ: ПЕРЕНЕСЕННЯ GRADLE НА ДИСК D:

### Переваги перенесення:
- **Звільняє 5-15 GB на диску C:**
- **Запобігає майбутнім проблемам з місцем**
- **Може прискорити збірку** (якщо D: швидший)
- **Централізоване керування кешами**

### Команди для перенесення:
```bash
# Перевірити поточне розташування
scripts\check_gradle_location.bat

# Перенести на D: диск
scripts\move_gradle_to_d.bat

# Відновити назад (якщо потрібно)
scripts\restore_gradle_to_c.bat
```

### Ручне перенесення:
```bash
# 1. Зупинити Gradle
gradlew --stop

# 2. Створити папку на D:
mkdir D:\gradle\.gradle

# 3. Перемістити кеш
robocopy "%USERPROFILE%\.gradle" "D:\gradle\.gradle" /E /MOVE

# 4. Встановити змінну оточення
setx GRADLE_USER_HOME "D:\gradle\.gradle"

# 5. Перезапустити IDE
```

## 📞 ДОДАТКОВА ДОПОМОГА

### Якщо проблема повторюється:
1. **Перенести Gradle кеш на диск D:** (РЕКОМЕНДОВАНО)
2. Збільшити місце на диску C:
3. Використовувати зовнішній build сервер
4. Збирати в Docker контейнері

### Корисні посилання:
- [Flutter build troubleshooting](https://flutter.dev/docs/deployment/android#build-an-apk)
- [Gradle memory settings](https://docs.gradle.org/current/userguide/build_environment.html)
- [Android build optimization](https://developer.android.com/studio/build/optimize-your-build)
