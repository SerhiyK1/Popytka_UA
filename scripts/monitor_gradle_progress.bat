@echo off
echo ========================================
echo GRADLE PROGRESS MONITOR - Popytka UA
echo ========================================

echo.
echo Monitoring Gradle recovery process...
echo Press Ctrl+C to stop monitoring
echo.

:loop
cls
echo ========================================
echo GRADLE PROGRESS MONITOR - %TIME%
echo ========================================

echo.
echo [1] Gradle Daemon Status:
cd android
call gradlew --status 2>nul
cd ..

echo.
echo [2] Current Gradle Cache Size:
if exist "%USERPROFILE%\.gradle\caches" (
    for /f "tokens=3" %%a in ('dir /s "%USERPROFILE%\.gradle\caches" 2^>nul ^| find "File(s)"') do set CacheSize=%%a
    if defined CacheSize (
        set /a SizeMB=!CacheSize!/1024/1024
        echo Gradle cache: !SizeMB! MB
    ) else (
        echo Gradle cache: Calculating...
    )
) else (
    echo Gradle cache: Not found
)

echo.
echo [3] Wrapper Download Status:
if exist "%USERPROFILE%\.gradle\wrapper\dists\gradle-8.12-all" (
    echo ✅ Gradle 8.12 wrapper downloaded
) else (
    echo ⏳ Downloading Gradle 8.12 wrapper...
)

echo.
echo [4] Available Disk Space:
for /f "tokens=3" %%a in ('dir /-c %SystemDrive%\ ^| find "bytes free"') do set FreeSpace=%%a
set /a FreeSpaceGB=!FreeSpace!/1024/1024/1024
echo %SystemDrive% drive: %FreeSpaceGB% GB free

echo.
echo [5] Build Process Status:
if exist "build\app\outputs\flutter-apk" (
    echo ✅ Build outputs directory exists
    dir /b "build\app\outputs\flutter-apk\*.apk" 2>nul
) else (
    echo ⏳ No build outputs yet
)

echo.
echo ========================================
echo Refreshing in 10 seconds... (Ctrl+C to stop)
echo ========================================

timeout /t 10 /nobreak >nul
goto :loop