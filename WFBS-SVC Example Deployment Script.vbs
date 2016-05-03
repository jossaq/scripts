pathOfWFBSHInstaller="msiexec /qn /i HostedAgent.msi"
strComputer = "." 
strOutput = ""
serviceCount = 0
totalServiceCountToCheck = 3

' check if WFBS-SVR is installed by detecting service ntrtscan, tmlisten, svcGenericHost are exist or not
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_Service")
For Each objService in colItems
	strOutput = strOutput & objService.name & vbCr & vbLf
	If objService.name = "ntrtscan" Then
		serviceCount = serviceCount + 1
'		Wscript.Echo "Service " & objService.Caption & " is " & objService.Started 
	ElseIf objService.name = "tmlisten" Then
		serviceCount = serviceCount + 1
'		Wscript.Echo "Service " & objService.Caption & " is " & objService.Started 
	ElseIf objService.name = "svcGenericHost" Then
		serviceCount = serviceCount + 1
'		Wscript.Echo "Service " & objService.Caption & " is " & objService.Started 
	End If
Next

If serviceCount <> totalServiceCountToCheck Then
	Dim WshShell
	Set WshShell = CreateObject("WScript.Shell")
	WshShell.Run pathOfWFBSHInstaller
End if


