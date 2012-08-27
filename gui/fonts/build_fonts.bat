:: No verbose echos
@echo off

:: Set filename to compile
set fonts_resource_file=fonts.qrc

:: Compile Qt .qrc File, Assume named %1.qrc, else
rbrcc -o "%fonts_resource_file%.rb" "%fonts_resource_file%"

:: Exit
goto :EOF

:EOF