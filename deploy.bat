@echo off
setlocal EnableDelayedExpansion

:: Configuration
set "PROJECT_ROOT=%CD%"
set "WEBAPP_NAME=Sprint1"
set "TOMCAT_HOME=C:\tomcat"
set "TOMCAT_WEBAPPS=%TOMCAT_HOME%\webapps"
set "BUILD_DIR=%PROJECT_ROOT%\build"

:: Check if Tomcat webapps directory exists
if not exist "%TOMCAT_WEBAPPS%" (
    echo Error: Tomcat webapps directory "%TOMCAT_WEBAPPS%" not found
    exit /b 1
)

:: Create temporary build directory
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

echo === Cleaning previous builds ===
if exist "%BUILD_DIR%" rd /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

echo === Copying web resources ===
:: Copy all files and directories from test to build
xcopy /E /I /Y "%PROJECT_ROOT%\*.*" "%BUILD_DIR%" /EXCLUDE:excludelist.txt
:: Create excludelist.txt to exclude deploy.bat and existing WAR file
echo deploy.bat>excludelist.txt
echo %WEBAPP_NAME%.war>>excludelist.txt
xcopy /E /I /Y "%PROJECT_ROOT%\WEB-INF" "%BUILD_DIR%\WEB-INF"

echo === Creating WAR file ===
cd "%BUILD_DIR%"
jar -cvf "%PROJECT_ROOT%\%WEBAPP_NAME%.war" .
if errorlevel 1 (
    echo Error: Failed to create WAR file
    cd "%PROJECT_ROOT%"
    del excludelist.txt
    exit /b 1
)
cd "%PROJECT_ROOT%"
del excludelist.txt

echo === Deploying to Tomcat ===
:: Remove old WAR and exploded directory if they exist
if exist "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%.war" del "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%.war"
if exist "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%" rd /s /q "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%"

:: Copy new WAR to Tomcat
copy "%WEBAPP_NAME%.war" "%TOMCAT_WEBAPPS%"
if errorlevel 1 (
    echo Error: Failed to deploy WAR to "%TOMCAT_WEBAPPS%"
    exit /b 1
)

:: Clean up
if exist "%BUILD_DIR%" rd /s /q "%BUILD_DIR%"

echo === Deployment completed ===
endlocal