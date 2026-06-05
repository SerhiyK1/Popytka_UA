@echo off
echo ========================================
echo POPYTKA UA - BUILD STATUS CHECK
echo ========================================

echo.
echo Checking build outputs...

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ Release APK found!
    for %%I in ("build\app\outputs\flutter-apk\app-release.apk") do echo    Size: %%~zI bytes
    echo    Location: build\app\outputs\flutter-apk\app-release.apk
) else (
    echo ❌ Release APK not found
)

echo.

if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo ✅ Release AAB found!
    for %%I in ("build\app\outputs\bundle\release\app-release.aab") do echo    Size: %%~zI bytes
    echo    Location: build\app\outputs\bundle\release\app-release.aab
) else (
    echo ❌ Release AAB not found
)

echo.
echo ========================================

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo 🚀 READY FOR TESTING!
    echo.
    echo Next steps:
    echo 1. Install APK on device: adb install build\app\outputs\flutter-apk\app-release.apk
    echo 2. Test all major features
    echo 3. Build AAB: flutter build appbundle --release
    echo 4. Upload to Play Console
) else (
    echo ⏳ Build still in progress...
    echo Run: flutter build apk --release
)

echo.
pause