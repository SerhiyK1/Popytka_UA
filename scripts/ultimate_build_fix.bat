@echo off
echo ========================================
echo ULTIMATE BUILD FIX - Popytka UA
echo ========================================

echo.
echo This script will solve ALL build issues:
echo 1. Check disk space and Gradle location
echo 2. Move Gradle to D: drive (if beneficial)
echo 3. Clean corrupted caches
echo 4. Build release APK
echo.

pause

echo.
echo [STEP 1] Analyzing current setup...
call scripts\check_gradle_location.bat

echo.
echo [STEP 2] Checking if Gradle move is beneficial...

:: Get C: drive free space
for /f "tokens=3" %%a in ('dir /-c C:\ ^| find "bytes free"') do set FreeCDrive=%%a
set /a FreeCGB=!FreeCDrive!/1024/1024/1024

:: Check if D: exists and has more space
set SHOULD_MOVE=false
if exist "D:\" (
    for /f "tokens=3" %%a in ('dir /-c D:\ ^| find "bytes free"') do set FreeDDrive=%%a
    set /a FreeDGB=!FreeDDrive!/1024/1024/1024
    
    if %FreeCGB% LSS 15 (
        if %FreeDGB% GTR 25 (
            set SHOULD_MOVE=true
            echo ✅ DECISION: Move Gradle to D: drive
            echo    C: drive: %FreeCGB% GB ^(low^)
            echo    D: drive: %FreeDGB% GB ^(sufficient^)
        )
    )
)

if "%SHOULD_MOVE%"=="true" (
    echo.
    echo [STEP 3] Moving Gradle to D: drive...
    call scripts\move_gradle_to_d.bat
    if %errorlevel% neq 0 goto :error
) else (
    echo.
    echo [STEP 3] Gradle location is OK, proceeding with cleanup...
)

echo.
echo [STEP 4] Emergency Gradle cleanup...
call scripts\emergency_gradle_fix.bat
if %errorlevel% neq 0 goto :error

echo.
echo [STEP 5] Building minimal APK for testing...
call scripts\build_minimal.bat
if %errorlevel% neq 0 goto :error

echo.
echo [STEP 6] Attempting full release build...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo ⚠️  Full build failed, but minimal APK should work
    echo Check: build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
) else (
    echo ✅ Full release APK built successfully!
    echo Check: build\app\outputs\flutter-apk\app-release.apk
)

echo.
echo ========================================
echo ✅ ULTIMATE FIX COMPLETED!
echo ========================================
echo.
echo Results:
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ Universal APK: build\app\outputs\flutter-apk\app-release.apk
)
if exist "build\app\outputs\flutter-apk\app-arm64-v8a-release.apk" (
    echo ✅ ARM64 APK: build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
)

echo.
echo Next steps:
echo 1. Test APK on device: adb install [apk-file]
echo 2. Build AAB: flutter build appbundle --release
echo 3. Upload to Google Play Console
echo.
goto :end

:error
echo.
echo ❌ ULTIMATE FIX FAILED!
echo.
echo Manual steps to try:
echo 1. Restart computer
echo 2. Run as Administrator
echo 3. Check antivirus software
echo 4. Free up more disk space manually
echo 5. Contact support with error details
echo.
exit /b 1

:end
pause