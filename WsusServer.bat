@echo OFF
setlocal ENABLEEXTENSIONS EnableDelayedExpansion
for /f "usebackq" %%i IN (`hostname`) DO SET host=%%i
set KEY_NAME="HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
set VALUE_NAME=WUServer

FOR /F "usebackq skip=2 tokens=1-2*" %%A IN (`REG QUERY %KEY_NAME% /v %VALUE_NAME% 2^>nul`) DO (
    set ValueName=%%A
    set ValueType=%%B
    set ValueValue=%host%,%%C
)

if defined ValueName (
   @echo %ValueValue% >> \\epmcc-pdc05\ScreenSaver\WsusServer.txt
) else (
    @echo %host%,%KEY_NAME%\%VALUE_NAME% not found. >> \\epmcc-pdc05\ScreenSaver\WsusServer.txt
)