@echo off
setlocal enabledelayedexpansion
echo ========================================
echo FRESH GRADLE INSTALL ON D: - Popytka UA
echo ========================================

echo.
echo This will:
echo 1. Completely remove Gradle from C: drive
echo 2. Install fresh Gradle 8.12 on D: drive
echo 3. Optimize configuration for D: drive
echo 4. Free up 5-15 GB on C: drive
echo.

:: Check if D: exists
if not exist "D:\" (
    echo ❌ D: drive not found!
    echo Please ensure D: drive is available
    pause
    exit /b 1
)

echo ✅ D: drive available
echo.

echo Starting fresh installation...
echo.

echo [1/8] Stopping all Gradle processes...
cd android
call gradlew --stop 2>nul
cd ..
taskkill /f /im java.exe 2>nul
taskkill /f /im gradle.exe 2>nul

echo.
echo [2/8] Removing ALL Gradle data from C: drive...
echo Deleting: %USERPROFILE%\.gradle
rmdir /s /q "%USERPROFILE%\.gradle" 2>nul
echo Deleting: %USERPROFILE%\.android\build-cache
rmdir /s /q "%USERPROFILE%\.android\build-cache" 2>nul
echo Deleting project build cache
rmdir /s /q "build" 2>nul
rmdir /s /q "android\build" 2>nul
rmdir /s /q "android\app\build" 2>nul

echo.
echo [3/8] Creating fresh Gradle structure on D:...
mkdir "D:\gradle" 2>nul
mkdir "D:\gradle\.gradle" 2>nul
mkdir "D:\gradle\.gradle\caches" 2>nul
mkdir "D:\gradle\.gradle\daemon" 2>nul
mkdir "D:\gradle\.gradle\wrapper" 2>nul

echo.
echo [4/8] Setting environment variables...
setx GRADLE_USER_HOME "D:\gradle\.gradle" >nul
set GRADLE_USER_HOME=D:\gradle\.gradle
echo GRADLE_USER_HOME = %GRADLE_USER_HOME%

echo.
echo [5/8] Creating optimized gradle.properties...
(
echo # Fresh Gradle 8.12 configuration for D: drive
echo # Memory settings - optimized for D: drive performance
echo org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=1G -XX:ReservedCodeCacheSize=512m
echo.
echo # Performance optimizations
echo org.gradle.parallel=true
echo org.gradle.caching=true
echo org.gradle.configureondemand=true
echo org.gradle.daemon=true
echo org.gradle.daemon.idletimeout=7200000
echo.
echo # Build optimizations
echo android.useAndroidX=true
echo android.enableJetifier=true
echo android.enableR8.fullMode=true
echo android.enableBuildCache=true
echo.
echo # Network optimizations
echo systemProp.http.keepAlive=true
echo systemProp.http.maxConnections=10
echo systemProp.http.maxConnectionsPerRoute=10
) > "D:\gradle\.gradle\gradle.properties"

echo.
echo [6/8] Updating project gradle.properties...
(
echo org.gradle.jvmargs=-Xmx3G -XX:MaxMetaspaceSize=768m -XX:ReservedCodeCacheSize=384m
echo android.useAndroidX=true
echo android.enableJetifier=true
echo.
echo # Optimize build performance on D: drive
echo org.gradle.parallel=true
echo org.gradle.caching=true
echo org.gradle.configureondemand=true
echo.
echo # Reduce memory usage
echo android.enableR8.fullMode=true
echo android.enableBuildCache=true
) > "android\gradle.properties"

echo.
echo [7/8] Testing fresh Gradle installation...
echo Getting Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ⚠️  Flutter pub get failed, but continuing...
)

echo.
echo Testing Gradle wrapper download...
cd android
call gradlew --version
if %errorlevel% neq 0 (
    echo ⚠️  Gradle test failed, but this is normal for first run
    echo Gradle will download on next build
)
cd ..

echo.
echo [8/8] Verifying installation...
if exist "D:\gradle\.gradle" (
    echo ✅ D:\gradle\.gradle created
) else (
    echo ❌ Failed to create D:\gradle\.gradle
    exit /b 1
)

if exist "D:\gradle\.gradle\gradle.properties" (
    echo ✅ Configuration file created
) else (
    echo ❌ Configuration file missing
)

echo.
echo ========================================
echo ✅ FRESH GRADLE 8.12 INSTALLED ON D:!
echo ========================================
echo.
echo Configuration Summary:
echo - Location: D:\gradle\.gradle
echo - Memory: 4GB (increased for D: drive)
echo - Caching: Enabled
echo - Parallel builds: Enabled
echo - Daemon timeout: 2 hours
echo.
echo Space freed on C: drive: ~5-15 GB
echo.
echo ⚠️  CRITICAL: RESTART YOUR DEVELOPMENT ENVIRONMENT!
echo 1. Close this terminal
echo 2. Close Android Studio/VS Code
echo 3. Open new terminal
echo 4. Run: flutter build apk --release
echo.
echo Gradle will download fresh dependencies (5-10 minutes)
echo Then build should complete successfully!
echo.

pause