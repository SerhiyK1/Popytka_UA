@echo off
echo ========================================
echo MINIMAL BUILD - Popytka UA
echo ========================================

echo.
echo Building minimal APK for testing...
echo.

echo [1/3] Setting minimal Gradle options...
set GRADLE_OPTS=-Xmx1g -XX:MaxMetaspaceSize=256m

echo.
echo [2/3] Building ARM64 APK only (smallest build)...
call flutter build apk --release --split-per-abi --target-platform android-arm64 --no-tree-shake-icons
if %errorlevel% neq 0 goto :error

echo.
echo [3/3] Checking result...
if exist "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" (
    echo ✅ ARM64 APK built successfully!
    for %%I in ("build\app\outputs\flutter-apk\app-arm64-v8a-release.apk") do (
        set size=%%~zI
        set /a sizeMB=!size!/1024/1024
        echo    Size: !sizeMB! MB
    )
    echo    Location: build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
) else (
    echo ❌ Build failed
    goto :error
)

echo.
echo ========================================
echo ✅ MINIMAL BUILD COMPLETED!
echo ========================================
echo.
echo Install on device:
echo adb install build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
echo.
echo This APK works on:
echo - All modern Android devices (ARM64)
echo - Android 6.0+ (API 23+)
echo.
goto :end

:error
echo.
echo ❌ MINIMAL BUILD FAILED!
echo Try: scripts\emergency_gradle_fix.bat
exit /b 1

:end
pause