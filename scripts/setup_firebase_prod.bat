@echo off
echo ========================================
echo FIREBASE PRODUCTION SETUP - Popytka UA
echo ========================================

echo.
echo This script will help you set up Firebase for production.
echo Make sure you have:
echo - Firebase CLI installed (npm install -g firebase-tools)
echo - Created Firebase project: popytka-ua-prod
echo - Downloaded google-services.json to android/app/
echo.

pause

echo.
echo [1/5] Logging into Firebase...
call firebase login
if %errorlevel% neq 0 goto :error

echo.
echo [2/5] Setting up project aliases...
call firebase use --add
echo Select your production project: popytka-ua-prod
echo Enter alias: production
if %errorlevel% neq 0 goto :error

echo.
echo [3/5] Initializing Firebase features...
call firebase init
echo Select:
echo - Firestore
echo - Storage
echo - Hosting (optional)
echo.
echo Use existing project: popytka-ua-prod
echo.
if %errorlevel% neq 0 goto :error

echo.
echo [4/5] Deploying security rules...
call firebase use production
call firebase deploy --only firestore:rules
call firebase deploy --only storage
if %errorlevel% neq 0 goto :error

echo.
echo [5/5] Verifying deployment...
call firebase projects:list
if %errorlevel% neq 0 goto :error

echo.
echo ========================================
echo ✅ FIREBASE PRODUCTION SETUP COMPLETED!
echo ========================================
echo.
echo Next steps:
echo 1. Verify google-services.json is in android/app/
echo 2. Create production keystore (see FIREBASE_PRODUCTION_SETUP.md)
echo 3. Update key.properties with production keystore
echo 4. Test with: flutter build apk --release
echo.
goto :end

:error
echo.
echo ❌ SETUP FAILED!
echo Check the error messages above.
echo See FIREBASE_PRODUCTION_SETUP.md for manual setup.
exit /b 1

:end
pause