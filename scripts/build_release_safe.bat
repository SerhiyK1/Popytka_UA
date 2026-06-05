@echo off
echo ========================================
echo POPYTKA UA - SAFE RELEASE BUILD
echo ========================================

echo.
echo Building with memory optimizations...
echo.

echo [1/4] Setting Gradle options for low memory...
set GRADLE_OPTS=-Xmx2g -XX:MaxMetaspaceSize=512m -XX:+HeapDumpOnOutOfMemoryError

echo.
echo [2/4] Building APK with optimizations...
call flutter build apk --release --split-per-abi --target-platform android-arm64
if %errorlevel% neq 0 goto :error

echo.
echo [3/4] Checking build results...
if exist "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" (
    echo ✅ ARM64 APK built successfully!
    for %%I in ("build\app\outputs\flutter-apk\app-arm64-v8a-release.apk") do echo    Size: %%~zI bytes
) else (
    echo ❌ ARM64 APK not found
    goto :error
)

echo.
echo [4/4] Building universal APK (if space allows)...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo ⚠️ Universal APK failed, but ARM64 APK is ready for testing
    goto :success
)

:success
echo.
echo ========================================
echo ✅ BUILD COMPLETED!
echo ========================================
echo.
echo Available APK files:
dir /b "build\app\outputs\flutter-apk\*.apk" 2>nul
echo.
echo Next steps:
echo 1. Test ARM64 APK: adb install build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
echo 2. If universal APK exists, test it too
echo 3. Build AAB when ready: flutter build appbundle --release
echo.
goto :end

:error
echo.
echo ❌ BUILD FAILED!
echo Try running: scripts\fix_build_space.bat
exit /b 1

:end
pause