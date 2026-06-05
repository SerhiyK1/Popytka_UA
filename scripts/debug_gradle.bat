@echo off
echo ========================================
echo GRADLE DEBUG INFO - Popytka UA
echo ========================================

echo.
echo [1] Flutter Doctor:
call flutter doctor -v

echo.
echo [2] Gradle Version:
cd android
call gradlew --version
cd ..

echo.
echo [3] Available Disk Space:
for /f "tokens=3" %%a in ('dir /-c %SystemDrive%\ ^| find "bytes free"') do set FreeSpace=%%a
echo Available space on %SystemDrive%: %FreeSpace% bytes

echo.
echo [4] Gradle Cache Size:
if exist "%USERPROFILE%\.gradle\caches" (
    for /f "tokens=3" %%a in ('dir /s "%USERPROFILE%\.gradle\caches" ^| find "File(s)"') do set CacheSize=%%a
    echo Gradle cache size: %CacheSize% bytes
) else (
    echo Gradle cache: NOT FOUND
)

echo.
echo [5] Project Build Size:
if exist "build" (
    for /f "tokens=3" %%a in ('dir /s "build" ^| find "File(s)"') do set BuildSize=%%a
    echo Project build size: %BuildSize% bytes
) else (
    echo Project build: NOT FOUND
)

echo.
echo [6] Android SDK:
if defined ANDROID_HOME (
    echo ANDROID_HOME: %ANDROID_HOME%
) else (
    echo ANDROID_HOME: NOT SET
)

echo.
echo [7] Java Version:
java -version

echo.
echo ========================================
echo DEBUG INFO COMPLETE
echo ========================================

pause