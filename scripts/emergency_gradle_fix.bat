@echo off
echo ========================================
echo EMERGENCY GRADLE CACHE FIX - Popytka UA
echo ========================================

echo.
echo ⚠️  WARNING: This will delete ALL Gradle caches!
echo This may take several minutes and require re-downloading dependencies.
echo.

pause

echo.
echo [1/8] Stopping any running Gradle daemons...
cd android
call gradlew --stop
cd ..

echo.
echo [2/8] Cleaning Flutter build...
call flutter clean

echo.
echo [3/8] Removing corrupted Gradle cache...
echo Deleting: %USERPROFILE%\.gradle\caches
rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
if exist "%USERPROFILE%\.gradle\caches" (
    echo ⚠️  Some files may be locked. Continuing...
)

echo.
echo [4/8] Removing Gradle wrapper cache...
rmdir /s /q "%USERPROFILE%\.gradle\wrapper" 2>nul

echo.
echo [5/8] Removing Android build cache...
rmdir /s /q "%USERPROFILE%\.android\build-cache" 2>nul

echo.
echo [6/8] Cleaning project build directory...
rmdir /s /q "build" 2>nul
rmdir /s /q "android\build" 2>nul
rmdir /s /q "android\app\build" 2>nul

echo.
echo [7/8] Getting Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 goto :error

echo.
echo [8/8] Testing Gradle configuration...
cd android
call gradlew tasks --console=plain
cd ..
if %errorlevel% neq 0 goto :error

echo.
echo ========================================
echo ✅ GRADLE CACHE FIXED!
echo ========================================
echo.
echo Now try building:
echo flutter build apk --release --split-per-abi --target-platform android-arm64
echo.
goto :end

:error
echo.
echo ❌ FIX FAILED!
echo.
echo Additional steps to try:
echo 1. Restart your computer
echo 2. Run as Administrator
echo 3. Check antivirus software
echo 4. Free up more disk space
echo.
exit /b 1

:end
pause