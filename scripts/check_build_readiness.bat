@echo off
echo ========================================
echo BUILD READINESS CHECK - Popytka UA
echo ========================================

echo.
echo Checking if system is ready for release build...
echo.

set READY=true

echo [1] Flutter Doctor Check:
call flutter doctor --android-licenses >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Android licenses may need acceptance
    echo Run: flutter doctor --android-licenses
)

echo.
echo [2] Gradle Daemon Status:
cd android
call gradlew --status
if %errorlevel% neq 0 (
    echo ❌ Gradle daemon not ready
    set READY=false
) else (
    echo ✅ Gradle daemon is running
)
cd ..

echo.
echo [3] Dependencies Check:
call flutter pub get >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter dependencies failed
    set READY=false
) else (
    echo ✅ Flutter dependencies OK
)

echo.
echo [4] Build Runner Check:
if exist "lib\**\*.g.dart" (
    echo ✅ Generated files exist
) else (
    echo ⚠️  Generated files missing, running build_runner...
    call dart run build_runner build --delete-conflicting-outputs
    if %errorlevel% neq 0 (
        echo ❌ Build runner failed
        set READY=false
    ) else (
        echo ✅ Build runner completed
    )
)

echo.
echo [5] Keystore Check:
if exist "android\upload-keystore.jks" (
    echo ✅ Keystore found
) else (
    echo ❌ Keystore missing
    set READY=false
)

if exist "android\key.properties" (
    echo ✅ Key properties found
) else (
    echo ❌ Key properties missing
    set READY=false
)

echo.
echo [6] Disk Space Check:
for /f "usebackq" %%a in (`powershell -NoProfile -Command "[math]::Floor((Get-PSDrive %SystemDrive:~0,1%).Free / 1GB)"`) do set FreeSpaceGB=%%a

if %FreeSpaceGB% LSS 5 (
    echo ❌ Insufficient disk space: %FreeSpaceGB% GB
    echo Need at least 5 GB for build
    set READY=false
) else (
    echo ✅ Sufficient disk space: %FreeSpaceGB% GB
)

echo.
echo [7] Firebase Config Check:
if exist "android\app\google-services.json" (
    echo ✅ Firebase config found
) else (
    echo ⚠️  Firebase config missing (will use demo mode)
)

echo.
echo ========================================
if "%READY%"=="true" (
    echo ✅ SYSTEM READY FOR BUILD!
    echo ========================================
    echo.
    echo Recommended build commands:
    echo.
    echo For testing:
    echo   flutter build apk --release --split-per-abi --target-platform android-arm64
    echo.
    echo For production:
    echo   flutter build apk --release
    echo   flutter build appbundle --release
    echo.
    echo Start build now? ^(y/n^)
    set /p startBuild=
    if /i "%startBuild%"=="y" (
        echo.
        echo Starting ARM64 build...
        call flutter build apk --release --split-per-abi --target-platform android-arm64
    )
) else (
    echo ❌ SYSTEM NOT READY
    echo ========================================
    echo.
    echo Please fix the issues above before building.
    echo.
    echo Quick fixes:
    echo - Run: flutter doctor --android-licenses
    echo - Run: scripts\emergency_gradle_fix.bat
    echo - Free up disk space
    echo - Check keystore configuration
)

echo.
pause