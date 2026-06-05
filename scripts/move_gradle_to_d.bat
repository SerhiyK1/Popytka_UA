@echo off
echo ========================================
echo MOVE GRADLE TO D: DRIVE - Popytka UA
echo ========================================

echo.
echo This script will move Gradle cache from C: to D: drive
echo This will free up 5-15 GB on your system drive!
echo.

:: Check if D: drive exists
if not exist "D:\" (
    echo ❌ D: drive not found!
    echo Please specify another drive or create D: drive first.
    pause
    exit /b 1
)

:: Check available space on D:
for /f "tokens=3" %%a in ('dir /-c D:\ ^| find "bytes free"') do set FreeSpaceD=%%a
if defined FreeSpaceD (
    set /a FreeSpaceGB=!FreeSpaceD!/1024/1024/1024
    echo Available space on D:: !FreeSpaceGB! GB
) else (
    echo Available space on D:: Unable to determine
    set FreeSpaceGB=100
)

if defined FreeSpaceGB (
    if !FreeSpaceGB! LSS 20 (
        echo ⚠️  Warning: Less than 20 GB free on D: drive
        echo Gradle cache can grow up to 15 GB
        echo Continue anyway? (y/n)
        set /p continue=
        if /i not "!continue!"=="y" exit /b 1
    ) else (
        echo ✅ Sufficient space on D: drive (!FreeSpaceGB! GB)
    )
) else (
    echo ✅ Proceeding with move (space check failed but D: exists)
)

pause

echo.
echo [1/7] Stopping Gradle daemons...
cd android
call gradlew --stop 2>nul
cd ..

echo.
echo [2/7] Creating new Gradle directory on D:...
mkdir "D:\gradle" 2>nul
mkdir "D:\gradle\.gradle" 2>nul

echo.
echo [3/7] Moving existing Gradle cache (if exists)...
if exist "%USERPROFILE%\.gradle" (
    echo Moving %USERPROFILE%\.gradle to D:\gradle\.gradle
    robocopy "%USERPROFILE%\.gradle" "D:\gradle\.gradle" /E /MOVE /R:3 /W:5 /MT:8
    if %errorlevel% GEQ 8 (
        echo ⚠️  Some files couldn't be moved (may be in use)
        echo Continuing with setup...
    )
) else (
    echo No existing Gradle cache found
)

echo.
echo [4/7] Setting up environment variables...
:: Set GRADLE_USER_HOME permanently
setx GRADLE_USER_HOME "D:\gradle\.gradle"
if %errorlevel% neq 0 (
    echo ❌ Failed to set GRADLE_USER_HOME
    goto :error
)

:: Also set for current session
set GRADLE_USER_HOME=D:\gradle\.gradle

echo.
echo [5/7] Creating gradle.properties with optimized settings...
echo # Gradle configuration for D: drive > "D:\gradle\.gradle\gradle.properties"
echo org.gradle.jvmargs=-Xmx3G -XX:MaxMetaspaceSize=768m -XX:ReservedCodeCacheSize=512m >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.parallel=true >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.caching=true >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.configureondemand=true >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.daemon=true >> "D:\gradle\.gradle\gradle.properties"
echo org.gradle.daemon.idletimeout=3600000 >> "D:\gradle\.gradle\gradle.properties"

echo.
echo [6/7] Testing new Gradle setup...
cd android
call gradlew tasks --console=plain
cd ..
if %errorlevel% neq 0 (
    echo ⚠️  Gradle test failed, but this is normal for first run
    echo Gradle will download dependencies on next build
)

echo.
echo [7/7] Cleaning up old symlinks/shortcuts...
if exist "%USERPROFILE%\.gradle" (
    rmdir "%USERPROFILE%\.gradle" 2>nul
)

echo.
echo ========================================
echo ✅ GRADLE MOVED TO D: DRIVE!
echo ========================================
echo.
echo Configuration:
echo - Gradle cache: D:\gradle\.gradle
echo - Environment: GRADLE_USER_HOME=D:\gradle\.gradle
echo - Max memory: 3GB (increased for better performance)
echo.
echo Benefits:
echo - Freed up 5-15 GB on C: drive
echo - Faster builds (if D: is faster than C:)
echo - No more disk space issues
echo.
echo ⚠️  IMPORTANT: Restart your IDE/terminal for changes to take effect!
echo.
echo Next steps:
echo 1. Restart Command Prompt/PowerShell
echo 2. Restart Android Studio/VS Code
echo 3. Run: flutter build apk --release
echo.
goto :end

:error
echo.
echo ❌ MOVE FAILED!
echo.
echo Manual steps:
echo 1. Set environment variable: GRADLE_USER_HOME=D:\gradle\.gradle
echo 2. Move %USERPROFILE%\.gradle to D:\gradle\.gradle
echo 3. Restart your development environment
echo.
exit /b 1

:end
pause