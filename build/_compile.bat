:: No verbose echos
@echo off

:: Check for argument
if "%1"=="" goto :missing_arg

:: Verify argument (.ui is present)
set filename_ui=%~nx1
set filename_verify=%filename_ui:.ui=%
if "%filename_verify%"=="%filename_ui%" goto :wrong_arg

:: Create normalized path for the .ui file to compile
set rel_path_with_filename_ini=%1
set rel_path_with_filename_ini=%rel_path_with_filename_ini:.ui=%
set rel_path_with_filename=%rel_path_with_filename_ini:\=/%

:: Create normalized path for the project root folder
set project_root_ini=%~dp0
set project_root_ini=%project_root_ini:build\=%
set project_root=%project_root_ini:\=/%

:: Wait for the specified number of seconds to compile
:: (Change if dealing with a larger GUI). Seems to be
:: working instantly, therefore 0 second wait.
set waittime=0*1000

:: Explicitly go to GUI dir
cd /d "%~dp0..\gui"

:: Check if supplied .ui File exists
if not exist %1 goto :arg_not_found

:: Compile Qt .ui File
rbuic4 -p -x "%1" > "%1.rb"
if not %errorlevel%==0 goto :error_rbuic

:: Wait for compilation to finish
ping 1.1.1.1 -n 1 -w %waittime% >NUL

:: Assume resource file is named %1.qrc
:: Prepare filenames for resource compilation
set uifile=%1
set resfile=%uifile:.ui=.qrc%

:: Compile Qt .qrc File, Assume named %1.qrc, else
rbrcc -name %filename_verify% "%resfile%" > "%rel_path_with_filename%.qrc.rb"

:: Wait for compilation to finish
ping 1.1.1.1 -n 1 -w %waittime% >NUL

:: Generate temporary file with .qtc.rb require, prepend to rb, merge
echo # Resource require via qt4-qtruby-qtdesigner-fix > "%cd%\%1.prepend"
echo require "Qt4"; require "%rel_path_with_filename%.qrc.rb" >> "%cd%\%1.prepend"
echo. >> "%cd%\%1.prepend"
copy /b "%cd%\%1.prepend" + "%cd%\%1.rb" "%cd%\%1.prepend.rb" >NUL

:: Delete old .rb file, .prepend file (since merged to .prepend.rb)
del /q "%cd%\%1.rb" > NUL
del /q "%cd%\%1.prepend" > NUL

:: Separate filename from %1, rename .prepend.rb file to %1.rb
ren "%cd%\%1.prepend.rb" "%~nx1.rb"

:: Fix the generated Qt4/Ruby file 
ruby -w "qt4-qtruby-qtdesigner-fix.rb" "%1.rb" "%1.cfg" "%3"

:: Run the fixed file by default, provide third argument to override
if "%3"=="" (

	:: Notify progress
	echo Fixing complete, running '%1.rb' . . .
	echo.

	:: Run the fixed file
	ruby -w -I"%project_root%" -r"%project_root%boot/main.rb" "%1.rb"
)

:: Return to the dir from which the script was executed
cd /d "%~dp0"

:: Exit
goto :EOF

:arg_not_found
echo FATAL ERROR: File '%1' does not exist !
goto :EOF

:missing_arg
echo FATAL ERROR: Missing first argument (a Qt Designer .ui File) !
goto :EOF

:wrong_arg
echo FATAL ERROR: Argument '%1' is not a Qt Designer .ui File!
goto :EOF

:EOF