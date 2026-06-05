@echo off
echo ========================================
echo POPYTKA UA - FIX BUILD SPACE ISSUE
echo ========================================

echo.
echo This script will clean up build caches to free disk space.
echo.

pause

echo.
echo [1/6] Cleaning Flutter build cache...
call flutter clean
if %errorlevel% neq 0 goto :error

echo.
echo [2/6] Cleaning Gradle cache...
cd android
call gradlew clean
cd ..
if %errorlevel% neq 0 goto :error

echo.
echo [3/6] Clearing Gradle user cache (this may take a while)...
rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
echo Gradle cache cleared.

echo.
echo [4/6] Getting Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 goto :error

echo.
echo [5/6] Running build_runner (if needed)...
call dart run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 goto :error

echo.
echo [6/6] Checking available disk space...
for /f "tokens=3" %%a in ('dir /-c %SystemDrive%\ ^| find "bytes free"') do set FreeSpace=%%a
echo Available space on %SystemDrive%: %FreeSpace% bytes

echo.
echo ========================================
echo ✅ CLEANUP COMPLETED!
echo ========================================
echo.
echo Now try building again:
echo flutter build apk --release
echo.
goto :end

:error
echo.
echo ❌ CLEANUP FAILED!
echo Check the error messages above.
exit /b 1

:end
pause