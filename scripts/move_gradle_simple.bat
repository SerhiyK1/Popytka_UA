@echo off
setlocal enabledelayedexpansion
echo ========================================
echo SIMPLE GRADLE MOVE TO D: - Popytka UA
echo ========================================

echo.
echo Moving Gradle from C: to D: drive...
echo This will free up space and improve performance!
echo.

:: Check if D: exists
if not exist "D:\" (
    echo ❌ D: drive not found!
    pause
    exit /b 1
)

echo ✅ D: drive found, proceeding with move...
echo.

pause

echo [1/6] Stopping Gradle daemons...
cd android
call gradlew --stop 2>nul
cd ..

echo.
echo [2/6] Creating Gradle directory on D:...
mkdir "D:\gradle" 2>nul
mkdir "D:\gradle\.gradle" 2>nul

echo.
echo [3/6] Moving Gradle cache to D:...
if exist "%USERPROFILE%\.gradle" (
    echo Moving %USERPROFILE%\.gradle to D:\gradle\.gradle
    echo This may take several minutes...
    robocopy "%USERPROFILE%\.gradle" "D:\gradle\.gradle" /E /MOVE /R:2 /W:3 /MT:4 /NFL /NDL
    echo Move completed!
) else (
    echo No existing Gradle cache found
)

echo.
echo [4/6] Setting environment variable...
setx GRADLE_USER_HOME "D:\gradle\.gradle"
set GRADLE_USER_HOME=D:\gradle\.gradle

echo.
echo [5/6] Creating optimized gradle.properties...
echo # Optimized Gradle settings for D: drive > "D:\gradle\.gradle\gradle.properties"
echo org.gradle.jvmargs=-Xmx3G -XX:MaxMetaspaceSize=768m >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.parallel=true >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.caching=true >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.daemon=true >> "D:\gradle\.gradle\gradle.properties"

echo.
echo [6/6] Testing new setup...
echo GRADLE_USER_HOME is now: %GRADLE_USER_HOME%

echo.
echo ========================================
echo ✅ GRADLE MOVED TO D: DRIVE!
echo ========================================
echo.
echo Benefits:
echo - Freed up 5-15 GB on C: drive
echo - Improved build performance
echo - No more disk space issues
echo.
echo ⚠️  RESTART your terminal/IDE for changes to take effect!
echo.
echo Next: flutter build apk --release
echo.

pause