@echo off
echo ========================================
echo   Generando codigo Freezed...
echo ========================================
echo.

call flutter pub run build_runner build --delete-conflicting-outputs

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Fallo al generar codigo
    pause
    exit /b %errorlevel%
)

echo.
echo ========================================
echo   Codigo generado exitosamente!
echo ========================================
echo.
pause
