@echo off
echo ========================================
echo Nettoyage et redeploiement complet
echo ========================================
echo.

REM Configuration
set "PROJECT_ROOT=%CD%\.."
set "FRAMEWORK_SRC=%PROJECT_ROOT%\framework\main\java"
set "TEST_SRC=%CD%"
set "BUILD_DIR=%PROJECT_ROOT%\framework\build"
set "TOMCAT_WEBAPPS=C:\tomcat\webapps"
set "WEBAPP_NAME=Sprint1"
set "SERVLET_API=%TEST_SRC%\WEB-INF\lib\jakarta.servlet-api_5.0.0.jar"

REM Etape 1: Nettoyage
echo 1. Nettoyage des anciens fichiers...
if exist "%BUILD_DIR%\classes" rmdir /s /q "%BUILD_DIR%\classes"
if exist "%BUILD_DIR%\framework.jar" del "%BUILD_DIR%\framework.jar"
if exist "%TEST_SRC%\WEB-INF\lib\framework.jar" del "%TEST_SRC%\WEB-INF\lib\framework.jar"
if exist "%TEST_SRC%\WEB-INF\classes" rmdir /s /q "%TEST_SRC%\WEB-INF\classes"

REM Etape 2: Creer les repertoires
echo 2. Creation des repertoires...
if not exist "%BUILD_DIR%\classes" mkdir "%BUILD_DIR%\classes"
if not exist "%TEST_SRC%\WEB-INF\lib" mkdir "%TEST_SRC%\WEB-INF\lib"
if not exist "%TEST_SRC%\WEB-INF\classes" mkdir "%TEST_SRC%\WEB-INF\classes"

REM Etape 3: Compilation du framework
echo 3. Compilation du framework...

REM Compiler les annotations de base
echo    - Compilation des annotations...
javac -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\annotations\Controller.java" "%FRAMEWORK_SRC%\com\example\annotations\GetMapping.java"
if errorlevel 1 (
    echo [ERREUR] Echec de la compilation des annotations!
    pause
    exit /b 1
)

REM Compiler les classes utilitaires (ordre important: MappingInfo en premier)
echo    - Compilation des utilitaires...
javac -classpath "%BUILD_DIR%\classes" -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\utilitaire\MappingInfo.java"
javac -classpath "%BUILD_DIR%\classes" -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\utilitaire\ConfigLoader.java"
javac -classpath "%BUILD_DIR%\classes" -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\utilitaire\ClassScanner.java"
javac -classpath "%BUILD_DIR%\classes" -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\utilitaire\UrlMappingRegistry.java"
if errorlevel 1 (
    echo [ERREUR] Echec de la compilation des utilitaires!
    pause
    exit /b 1
)

REM Compiler AnnotationReader qui depend des utilitaires
echo    - Compilation de AnnotationReader...
javac -classpath "%BUILD_DIR%\classes" -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\annotations\AnnotationReader.java"
if errorlevel 1 (
    echo [ERREUR] Echec de la compilation de AnnotationReader!
    pause
    exit /b 1
)

REM Compiler les servlets
echo    - Compilation des servlets...
if exist "%SERVLET_API%" (
    javac -classpath "%SERVLET_API%;%BUILD_DIR%\classes" -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\servlet\FrontServlet.java"
    if errorlevel 1 (
        echo [ERREUR] Echec de la compilation de FrontServlet!
        pause
        exit /b 1
    )
    javac -classpath "%SERVLET_API%;%BUILD_DIR%\classes" -d "%BUILD_DIR%\classes" "%FRAMEWORK_SRC%\com\example\utilitaire\ResourceFilter.java" "%FRAMEWORK_SRC%\com\example\utilitaire\UrlTestServlet.java"
    if errorlevel 1 (
        echo [ERREUR] Echec de la compilation de ResourceFilter/UrlTestServlet!
        pause
        exit /b 1
    )
    echo    - Servlets compiles avec succes
) else (
    echo [ERREUR] jakarta.servlet-api_5.0.0.jar introuvable dans WEB-INF/lib!
    echo Chemin recherche: %SERVLET_API%
    pause
    exit /b 1
)

REM Etape 4: Creation du JAR du framework
echo 4. Creation du framework.jar...
cd "%BUILD_DIR%"
jar cvf framework.jar -C classes .
if errorlevel 1 (
    echo [ERREUR] Echec de la creation du JAR!
    cd "%TEST_SRC%"
    pause
    exit /b 1
)
cd "%TEST_SRC%"

REM Etape 5: Copie du JAR dans WEB-INF/lib
echo 5. Copie du framework.jar dans WEB-INF/lib...
copy "%BUILD_DIR%\framework.jar" "%TEST_SRC%\WEB-INF\lib\"
if errorlevel 1 (
    echo [ERREUR] Echec de la copie du JAR!
    pause
    exit /b 1
)

REM Etape 6: Compilation des controleurs de test
echo 6. Compilation des controleurs de test...

REM Copier config.properties
echo    - Copie de config.properties...
copy "%TEST_SRC%\config.properties" "%TEST_SRC%\WEB-INF\classes\"

REM Compiler les controleurs
echo    - Compilation des controleurs...
javac -classpath "%TEST_SRC%\WEB-INF\lib\framework.jar" -d "%TEST_SRC%\WEB-INF\classes" "%TEST_SRC%\com\example\controller\*.java"
if errorlevel 1 (
    echo [ERREUR] Echec de la compilation des controleurs!
    pause
    exit /b 1
)

REM Compiler admin
echo    - Compilation des admin...
javac -classpath "%TEST_SRC%\WEB-INF\lib\framework.jar;%TEST_SRC%\WEB-INF\classes" -d "%TEST_SRC%\WEB-INF\classes" "%TEST_SRC%\com\example\admin\*.java"
if errorlevel 1 (
    echo [ERREUR] Echec de la compilation des admin!
    pause
    exit /b 1
)

REM Compiler util
echo    - Compilation des util...
javac -classpath "%TEST_SRC%\WEB-INF\lib\framework.jar;%TEST_SRC%\WEB-INF\classes" -d "%TEST_SRC%\WEB-INF\classes" "%TEST_SRC%\com\example\util\*.java"
if errorlevel 1 (
    echo [ERREUR] Echec de la compilation des util!
    pause
    exit /b 1
)

REM Compiler Main
echo    - Compilation de Main...
javac -classpath "%TEST_SRC%\WEB-INF\lib\framework.jar;%TEST_SRC%\WEB-INF\classes" -d "%TEST_SRC%\WEB-INF\classes" "%TEST_SRC%\Main.java"
if errorlevel 1 (
    echo [ERREUR] Echec de la compilation de Main!
    pause
    exit /b 1
)

REM Etape 7: Verification
echo 7. Verification du contenu du JAR...
jar tf "%TEST_SRC%\WEB-INF\lib\framework.jar" | findstr "ResourceFilter"
if errorlevel 1 (
    echo [AVERTISSEMENT] ResourceFilter.class non trouve dans le JAR
)

echo.
echo ========================================
echo Compilation terminee avec succes!
echo ========================================
echo.

REM Etape 8: Creation du WAR et deploiement
echo 8. Creation du WAR et deploiement...

REM Creer un fichier excludelist temporaire
(
    echo redeploy.bat
    echo deploy.bat
    echo compile_annotations.bat
    echo %WEBAPP_NAME%.war
    echo config.properties
    echo Main.java
    echo TestFramework.java
    echo Teste.java
    echo AnnotationTestRunner.java
    echo ClassWithoutAnnotations.java
    echo SimpleControllerWithoutClassAnnotation.java
    echo TestControllerWithAnnotations.java
    echo com\
)>excludelist.txt

REM Creer un repertoire temporaire pour le WAR
if exist "temp_war" rmdir /s /q "temp_war"
mkdir "temp_war"

REM Copier les fichiers necessaires
echo    - Copie des ressources web...
xcopy "%TEST_SRC%\*.jsp" "temp_war\" /Y >nul 2>&1
xcopy "%TEST_SRC%\*.css" "temp_war\" /Y >nul 2>&1
xcopy "%TEST_SRC%\*.html" "temp_war\" /Y >nul 2>&1
xcopy "%TEST_SRC%\WEB-INF" "temp_war\WEB-INF\" /E /I /Y >nul

REM Creer le WAR
cd temp_war
jar -cvf "%TEST_SRC%\%WEBAPP_NAME%.war" .
if errorlevel 1 (
    echo [ERREUR] Echec de la creation du WAR!
    cd "%TEST_SRC%"
    rmdir /s /q "temp_war"
    del excludelist.txt
    pause
    exit /b 1
)
cd "%TEST_SRC%"
rmdir /s /q "temp_war"
del excludelist.txt

echo    - WAR cree: %WEBAPP_NAME%.war

REM Deploiement vers Tomcat
if exist "%TOMCAT_WEBAPPS%" (
    echo    - Deploiement vers Tomcat...
    
    REM Supprimer l'ancienne application
    if exist "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%.war" del "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%.war"
    if exist "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%" rmdir /s /q "%TOMCAT_WEBAPPS%\%WEBAPP_NAME%"
    
    REM Copier le nouveau WAR
    copy "%TEST_SRC%\%WEBAPP_NAME%.war" "%TOMCAT_WEBAPPS%\"
    if errorlevel 1 (
        echo [ERREUR] Echec du deploiement vers Tomcat
    ) else (
        echo    - Deploye dans %TOMCAT_WEBAPPS%\%WEBAPP_NAME%.war
    )
) else (
    echo [AVERTISSEMENT] Tomcat webapps non trouve: %TOMCAT_WEBAPPS%
    echo Le WAR est cree mais non deploye automatiquement.
)

echo.
echo ========================================
echo DEPLOIEMENT TERMINE!
echo ========================================
echo.
echo INSTRUCTIONS:
echo 1. Redemarrez Tomcat
echo 2. Accedez a: http://localhost:8080/%WEBAPP_NAME%/testUrl
echo 3. Testez les URLs: /test, /hello, /simple, /admin/dashboard
echo.
pause
