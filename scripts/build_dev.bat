@echo off
echo Construyendo APK de desarrollo...
flutter build apk --flavor dev --debug
echo.
echo Build completado!
echo APK ubicado en: build\app\outputs\flutter-apk\
pause
