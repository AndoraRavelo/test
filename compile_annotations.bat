@echo off
echo Compilation des annotations et du test...

REM Créer les répertoires de build s'ils n'existent pas
if not exist "..\framework\build\classes" mkdir "..\framework\build\classes"

REM Compilation des annotations
echo Compilation des annotations...
javac -d "..\framework\build\classes" ..\framework\main\java\com\example\annotations\*.java

if errorlevel 1 (
    echo Erreur de compilation des annotations!
    pause
    exit /b 1
)

REM Compilation des servlets
echo Compilation des servlets...
javac -classpath "WEB-INF\lib\jakarta.servlet-api_5.0.0.jar;..\framework\build\classes" -d "..\framework\build\classes" ..\framework\main\java\com\example\servlet\*.java

if errorlevel 1 (
    echo Erreur de compilation des servlets!
    pause
    exit /b 1
)

REM Compilation du test
echo Compilation du test...
javac -classpath "..\framework\build\classes" -d "..\framework\build\classes" *.java

if errorlevel 1 (
    echo Erreur de compilation du test!
    pause
    exit /b 1
)

echo Compilation réussie!
echo.
echo Pour tester les annotations:
echo java -cp "..\framework\build\classes" TestFramework
echo.
pause
