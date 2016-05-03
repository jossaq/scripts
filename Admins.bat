@echo off
SetLocal EnableDelayedExpansion
for /f "usebackq" %%i IN (`hostname`) DO SET host=%%i
for /f "skip=4 tokens=*" %%a in ('net group Administradores') DO SET M=!M!%%a:::
set "salida=%host% ::: %M%"
for /F "tokens=*" %%i IN ('ECHO %salida%') DO SET y=%%i
set y=%y: =,%
::ECHO %y% >> \\epmcc-pdc05\ScreenSaver\NetShare.txt