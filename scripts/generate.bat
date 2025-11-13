@echo off
echo Generando codigo con build_runner...
flutter pub run build_runner build --delete-conflicting-outputs
echo.
echo Generacion completada!
pause
