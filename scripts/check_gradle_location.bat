@echo off
echo ========================================
echo GRADLE LOCATION CHECK - Popytka UA
echo ========================================

echo.
echo [1] Current GRADLE_USER_HOME:
if defined GRADLE_USER_HOME (
    echo GRADLE_USER_HOME = %GRADLE_USER_HOME%
) else (
    echo GRADLE_USER_HOME = NOT SET (using default: %USERPROFILE%\.gradle)
)

echo.
echo [2] Gradle cache locations:

:: Check default location
if exist "%USERPROFILE%\.gradle" (
    echo ✅ Found: %USERPROFILE%\.gradle
    for /f "tokens=3" %%a in ('dir /s "%USERPROFILE%\.gradle" 2^>nul ^| find "File(s)"') do set SizeC=%%a
    if defined SizeC (
        set /a SizeMB=!SizeC!/1024/1024
        echo    Size: !SizeMB! MB
    )
) else (
    echo ❌ Not found: %USERPROFILE%\.gradle
)

:: Check D: drive location
if exist "D:\gradle\.gradle" (
    echo ✅ Found: D:\gradle\.gradle
    for /f "tokens=3" %%a in ('dir /s "D:\gradle\.gradle" 2^>nul ^| find "File(s)"') do set SizeD=%%a
    if defined SizeD (
        set /a SizeMB=!SizeD!/1024/1024
        echo    Size: !SizeMB! MB
    )
) else (
    echo ❌ Not found: D:\gradle\.gradle
)

:: Check other common locations
if exist "E:\gradle\.gradle" (
    echo ✅ Found: E:\gradle\.gradle
)

echo.
echo [3] Disk space analysis:

:: C: drive space
for /f "tokens=3" %%a in ('dir /-c C:\ ^| find "bytes free"') do set FreeCDrive=%%a
set /a FreeCGB=!FreeCDrive!/1024/1024/1024
echo C: drive free space: %FreeCGB% GB

:: D: drive space (if exists)
if exist "D:\" (
    for /f "tokens=3" %%a in ('dir /-c D:\ ^| find "bytes free"') do set FreeDDrive=%%a
    set /a FreeDGB=!FreeDDrive!/1024/1024/1024
    echo D: drive free space: %FreeDGB% GB
) else (
    echo D: drive: NOT AVAILABLE
)

echo.
echo [4] Recommendations:

if %FreeCGB% LSS 10 (
    echo ⚠️  C: drive is low on space ^(%FreeCGB% GB^)
    if exist "D:\" (
        if %FreeDGB% GTR 20 (
            echo ✅ RECOMMENDED: Move Gradle to D: drive
            echo    Run: scripts\move_gradle_to_d.bat
        ) else (
            echo ⚠️  D: drive also low on space ^(%FreeDGB% GB^)
        )
    ) else (
        echo ❌ No D: drive available for moving Gradle
        echo    Consider: 
        echo    - Cleaning temporary files
        echo    - Moving other large folders
        echo    - Adding external drive
    )
) else (
    echo ✅ C: drive has sufficient space ^(%FreeCGB% GB^)
    if exist "D:\" (
        if %FreeDGB% GTR %FreeCGB% (
            echo 💡 OPTIONAL: D: drive has more space ^(%FreeDGB% GB^)
            echo    Moving Gradle could improve performance
        )
    )
)

echo.
echo [5] Current Gradle version:
cd android
call gradlew --version 2>nul
cd ..

echo.
echo ========================================
echo LOCATION CHECK COMPLETE
echo ========================================

pause