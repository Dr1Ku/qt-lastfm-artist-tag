:: No verbose echos
@echo off

:: Check for argument
if "%1"=="" goto :missing_args

:: Explicitly go to GUI dir
cd /d "%~dp0\..\gui"

:: Notify course of action
echo Running '%1.rb' . . .

:: Run the fixed file
ruby -w "%1.rb"

:: Return to current dir
cd /d "%~dp0"

:: Exit
goto :EOF

:missing_arg
echo FATAL ERROR: Missing argument (a Qt .ui File) !
goto :EOF

:EOF