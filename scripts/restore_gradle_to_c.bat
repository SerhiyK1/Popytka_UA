@echo off
echo ========================================
echo RESTORE GRADLE TO C: DRIVE - Popytka UA
echo ========================================

echo.
echo This script will restore Gradle cache back to C: drive
echo (default location: %USERPROFILE%\.gradle)
echo.

if not exist "D:\gradle\.gradle" (
    echo ❌ No Gradle cache found on D: drive
    echo Nothing to restore.
    pause
    exit /b 1
)

pause

echo.
echo [1/5] Stopping Gradle daemons...
cd android
call gradlew --stop 2>nul
cd ..

echo.
echo [2/5] Moving Gradle cache back to C:...
if exist "%USERPROFILE%\.gradle" (
    echo Removing existing cache on C:...
    rmdir /s /q "%USERPROFILE%\.gradle"
)

echo Moving D:\gradle\.gradle to %USERPROFILE%\.gradle
robocopy "D:\gradle\.gradle" "%USERPROFILE%\.gradle" /E /MOVE /R:3 /W:5 /MT:8
if %errorlevel% GEQ 8 (
    echo ⚠️  Some files couldn't be moved
    echo Manual cleanup may be required
)

echo.
echo [3/5] Removing environment variable...
setx GRADLE_USER_HOME ""
set GRADLE_USER_HOME=

echo.
echo [4/5] Cleaning up D: drive...
if exist "D:\gradle" (
    rmdir /s /q "D:\gradle" 2>nul
)

echo.
echo [5/5] Testing restored Gradle setup...
cd android
call gradlew tasks --console=plain
cd ..

echo.
echo ========================================
echo ✅ GRADLE RESTORED TO C: DRIVE!
echo ========================================
echo.
echo Configuration:
echo - Gradle cache: %USERPROFILE%\.gradle (default)
echo - Environment: GRADLE_USER_HOME removed
echo.
echo ⚠️  IMPORTANT: Restart your IDE/terminal for changes to take effect!
echo.

pause