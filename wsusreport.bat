@echo off
net stop wuauserv
regsvr32 /s msxml3.dll
regsvr32 /s wups.dll
regsvr32 /s wuapi.dll
regsvr32 /s wuaueng.dll
regsvr32 /s wucltui.dll
net start wuauserv
wuauclt.exe /resetauthorization /detectnow
ping 127.0.0.1 -n 6 > nul