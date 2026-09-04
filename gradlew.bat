@rem
@rem Gradle Wrapper startup script for Windows.
@rem Licensed under the Apache License, Version 2.0
@rem

@if "%DEBUG%"=="" @echo off
@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%
set CLASSPATH=%APP_HOME%\gradle\wrapper\gradle-wrapper.jar

@rem Locate the java command.
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if %ERRORLEVEL% equ 0 goto execute

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo Please install a Java 17 JDK (or set JAVA_HOME) and try again.
goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%\bin\java.exe
if exist "%JAVA_EXE%" goto execute

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
goto fail

:execute
if not exist "%CLASSPATH%" (
    echo.
    echo ERROR: %CLASSPATH% is missing.
    echo The Gradle wrapper JAR must be committed to the repository.
    goto fail
)

"%JAVA_EXE%" -Xmx64m -Xms64m %JAVA_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*
if %ERRORLEVEL% equ 0 goto end

:fail
if not ""=="%GRADLE_EXIT_CONSOLE%" exit 1
exit /b 1

:end
if "%OS%"=="Windows_NT" endlocal
