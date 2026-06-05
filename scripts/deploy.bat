@echo off
echo ========================================
echo POPYTKA UA - DEPLOYMENT SCRIPT
echo ========================================

echo.
echo [1/6] Cleaning project...
call flutter clean
if %errorlevel% neq 0 goto :error

echo.
echo [2/6] Getting dependencies...
call flutter pub get
if %errorlevel% neq 0 goto :error

echo.
echo [3/6] Running build_runner...
call dart run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 goto :error

echo.
echo [4/6] Generating launcher icons...
call dart run flutter_launcher_icons:main
if %errorlevel% neq 0 goto :error

echo.
echo [5/6] Building release APK...
call flutter build apk --release
if %errorlevel% neq 0 goto :error

echo.
echo [6/6] Building release App Bundle...
call flutter build appbundle --release
if %errorlevel% neq 0 goto :error

echo.
echo ========================================
echo ✅ DEPLOYMENT BUILD COMPLETED!
echo ========================================
echo.
echo Release files location:
echo APK: build\app\outputs\flutter-apk\app-release.apk
echo AAB: build\app\outputs\bundle\release\app-release.aab
echo.
echo Next steps:
echo 1. Test the release APK on real devices
echo 2. Upload AAB to Google Play Console
echo 3. Deploy Firebase security rules
echo.
goto :end

:error
echo.
echo ❌ BUILD FAILED!
echo Check the error messages above.
exit /b 1

:end
pause