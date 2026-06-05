@echo off
setlocal enabledelayedexpansion
echo ========================================
echo VERIFY GRADLE ON D: DRIVE - Popytka UA
echo ========================================

echo.
echo Checking Gradle installation on D: drive...
echo.

echo [1] Environment Variables:
if defined GRADLE_USER_HOME (
    echo ✅ GRADLE_USER_HOME = %GRADLE_USER_HOME%
    if "%GRADLE_USER_HOME%"=="D:\gradle\.gradle" (
        echo ✅ Correctly set to D: drive
    ) else (
        echo ⚠️  Not pointing to D: drive
    )
) else (
    echo ❌ GRADLE_USER_HOME not set
)

echo.
echo [2] Directory Structure:
if exist "D:\gradle\.gradle" (
    echo ✅ D:\gradle\.gradle exists
    
    if exist "D:\gradle\.gradle\gradle.properties" (
        echo ✅ Configuration file exists
    ) else (
        echo ❌ Configuration file missing
    )
    
    if exist "D:\gradle\.gradle\caches" (
        echo ✅ Caches directory exists
    ) else (
        echo ℹ️  Caches directory will be created on first build
    )
    
    if exist "D:\gradle\.gradle\wrapper" (
        echo ✅ Wrapper directory exists
    ) else (
        echo ℹ️  Wrapper directory will be created on first build
    )
) else (
    echo ❌ D:\gradle\.gradle does not exist
    echo Run: scripts\fresh_gradle_install_d.bat
)

echo.
echo [3] Old C: Drive Cleanup:
if exist "%USERPROFILE%\.gradle" (
    echo ⚠️  Old Gradle still exists on C: drive
    echo Location: %USERPROFILE%\.gradle
    echo Recommendation: Delete to free space
) else (
    echo ✅ C: drive cleaned (no old Gradle found)
)

echo.
echo [4] Disk Space Analysis:
for /f "tokens=3" %%a in ('dir /-c C:\ ^| find "bytes free"') do set FreeCDrive=%%a
if defined FreeCDrive (
    set /a FreeCGB=!FreeCDrive!/1024/1024/1024
    echo C: drive free space: !FreeCGB! GB
) else (
    echo C: drive space: Unable to determine
)

if exist "D:\" (
    for /f "tokens=3" %%a in ('dir /-c D:\ ^| find "bytes free"') do set FreeDDrive=%%a
    if defined FreeDDrive (
        set /a FreeDGB=!FreeDDrive!/1024/1024/1024
        echo D: drive free space: !FreeDGB! GB
    ) else (
        echo D: drive space: Unable to determine
    )
) else (
    echo ❌ D: drive not accessible
)

echo.
echo [5] Gradle Version Test:
cd android
echo Testing Gradle wrapper...
call gradlew --version 2>nul
if %errorlevel% equ 0 (
    echo ✅ Gradle wrapper working
) else (
    echo ⚠️  Gradle wrapper not ready (normal for fresh install)
    echo Will download on first build
)
cd ..

echo.
echo [6] Flutter Dependencies:
call flutter doctor --android-licenses >nul 2>&1
call flutter pub get >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Flutter dependencies OK
) else (
    echo ⚠️  Flutter dependencies need attention
)

echo.
echo ========================================
echo VERIFICATION COMPLETE
echo ========================================

echo.
if exist "D:\gradle\.gradle" (
    if defined GRADLE_USER_HOME (
        if "%GRADLE_USER_HOME%"=="D:\gradle\.gradle" (
            echo ✅ GRADLE ON D: DRIVE IS READY!
            echo.
            echo Next steps:
            echo 1. Restart terminal/IDE if not done already
            echo 2. Run: flutter build apk --release
            echo 3. First build will take 10-15 minutes (downloading dependencies)
            echo 4. Subsequent builds will be much faster
        ) else (
            echo ⚠️  Environment variable needs correction
        )
    ) else (
        echo ⚠️  Environment variable not set
    )
) else (
    echo ❌ Gradle installation incomplete
    echo Run: scripts\fresh_gradle_install_d.bat
)

echo.
pause