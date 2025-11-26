@echo off
echo ========================================
echo   Pizzas Reyna - Setup Script
echo ========================================
echo.

echo [1/4] Instalando dependencias...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Fallo al instalar dependencias
    pause
    exit /b %errorlevel%
)
echo.

echo [2/4] Generando codigo Freezed...
call flutter pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo ERROR: Fallo al generar codigo
    pause
    exit /b %errorlevel%
)
echo.

echo [3/4] Verificando archivo .env...
if not exist ".env" (
    echo Copiando .env.example a .env...
    copy .env.example .env
    echo.
    echo IMPORTANTE: Edita el archivo .env con tu configuracion
    echo.
) else (
    echo Archivo .env ya existe
)
echo.

echo [4/4] Setup completado!
echo.
echo ========================================
echo   Proximos pasos:
echo ========================================
echo 1. Edita el archivo .env si es necesario
echo 2. Asegurate de que el backend este corriendo
echo 3. Ejecuta: flutter run
echo.
echo Para mas informacion, lee SETUP_INSTRUCTIONS.md
echo.
pause
