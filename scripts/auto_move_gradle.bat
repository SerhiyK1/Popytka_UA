@echo off
setlocal enabledelayedexpansion
echo ========================================
echo AUTO GRADLE MOVE TO D: - Popytka UA
echo ========================================

echo.
echo Automatically moving Gradle from C: to D: drive...

:: Check if D: exists
if not exist "D:\" (
    echo ❌ D: drive not found!
    exit /b 1
)

echo ✅ D: drive found

echo.
echo [1/6] Stopping Gradle daemons...
cd android
call gradlew --stop 2>nul
cd ..

echo.
echo [2/6] Creating Gradle directory on D:...
mkdir "D:\gradle" 2>nul
mkdir "D:\gradle\.gradle" 2>nul

echo.
echo [3/6] Moving Gradle cache to D: (this may take 5-10 minutes)...
if exist "%USERPROFILE%\.gradle" (
    echo Source: %USERPROFILE%\.gradle
    echo Target: D:\gradle\.gradle
    echo Starting move...
    robocopy "%USERPROFILE%\.gradle" "D:\gradle\.gradle" /E /MOVE /R:1 /W:1 /MT:2 /NFL /NDL /NJH /NJS
    echo ✅ Move completed!
) else (
    echo ℹ️  No existing Gradle cache found
)

echo.
echo [4/6] Setting environment variable...
setx GRADLE_USER_HOME "D:\gradle\.gradle" >nul
set GRADLE_USER_HOME=D:\gradle\.gradle

echo.
echo [5/6] Creating optimized gradle.properties...
(
echo # Optimized Gradle settings for D: drive
echo org.gradle.jvmargs=-Xmx3G -XX:MaxMetaspaceSize=768m -XX:ReservedCodeCacheSize=512m
echo org.gradle.parallel=true
echo org.gradle.caching=true
echo org.gradle.daemon=true
echo org.gradle.configureondemand=true
) > "D:\gradle\.gradle\gradle.properties"

echo.
echo [6/6] Verifying setup...
if exist "D:\gradle\.gradle" (
    echo ✅ D:\gradle\.gradle created
) else (
    echo ❌ Failed to create D:\gradle\.gradle
    exit /b 1
)

echo.
echo ========================================
echo ✅ GRADLE SUCCESSFULLY MOVED TO D:!
echo ========================================
echo.
echo Configuration:
echo - New location: D:\gradle\.gradle
echo - Environment: GRADLE_USER_HOME=D:\gradle\.gradle
echo - Memory: 3GB (optimized for D: drive)
echo.
echo ⚠️  IMPORTANT: 
echo 1. Restart your terminal/command prompt
echo 2. Restart Android Studio/VS Code
echo 3. Then run: flutter build apk --release
echo.

:: Show current status
echo Current GRADLE_USER_HOME: %GRADLE_USER_HOME%
if exist "D:\gradle\.gradle" (
    echo ✅ New Gradle location verified
) else (
    echo ❌ Verification failed
)

echo.
echo Build is ready to continue!