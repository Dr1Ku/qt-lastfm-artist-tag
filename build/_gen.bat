:: No verbose echos
@echo off

:: Check if first parameter present
if "%1"=="" goto :missing_args

:: Extract filename from the given .ui file (first parameter)
set filename_ui=%~nx1
set filename=%filename_ui:.ui=%

:: Verify argument (.ui is present)
set filename_verify=%filename_ui:.ui=%
if "%filename_verify%"=="%filename_ui%" goto :wrong_arg

:: Replace intermediate string with real string, write to file
echo _compile %1 %filename%.ui.cfg %%1 > compile_%filename%.bat
echo _run %1 > run_%filename%.bat

:: Notify completion
echo Generated 'compile_%filename%.bat' and 'run_%filename%.bat' successfully

:: Exit
goto :EOF

:missing_arg
echo FATAL ERROR: Missing argument (a Qt Designer .ui File for which to generate compile and run) !
goto :EOF

:wrong_arg
echo FATAL ERROR: Argument '%1' is not a Qt Designer .ui File!
goto :EOF

:EOF