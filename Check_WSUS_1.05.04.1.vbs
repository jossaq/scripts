'--------------------------------------------
' Einstellungen für die automatischen Updates
' http://www.wsus.de/
' Version 1.05.04.1
' Translated quick and dirty into English Marco Biagini
' mbiagini@ehsd.cccounty.us
'--------------------------------------------
On Error Resume Next

Set objWshNet = CreateObject("Wscript.Network")

const HKCU = &H80000001
const HKLM = &H80000002

strDefComputer = lcase(objWshNet.ComputerName)

Set oArgs = WScript.Arguments
If oArgs.Count = 0 Then
 strComputer = InputBox("Please enter the name or IP address of the Computer that you want to check WSUS settings", "Automatic Updates", strDefComputer)
Else
 strComputer = oArgs(0)
End If

If strComputer = "" Then
 WScript.Quit
End if

strComputer = lcase(strComputer)
if left(strComputer,2)="\\" then
 strComputer=right(strComputer,(len(strComputer)-2))
end if

Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")

If Err.Number <> 0 Then
 msgbox "Unable to connect to:" & VBCRLF & VBCRLF & "     " & strComputer & VBCRLF, vbCritical, "Communication Error"
 WScript.Quit
End If

Resultmsg = "**** Results of WSUS Settings ****" & VBCRLF & VBCRLF

strMsg = "No Auto Update:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "NoAutoUpdate"
If RegValueExists(strKeyPath, strValueName) Then
 oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
 Resultmsg = Resultmsg & strMsg & GetNoAutoUpdate(dwValue) & VBCRLF & VBCRLF
Else
 Resultmsg = Resultmsg & strMsg & "Automatic Updates are not configured" & VBCRLF & VBCRLF
End If

strMsg = "Use WU Server:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "UseWUServer"
If RegValueExists(strKeyPath, strValueName) Then
 oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
 Resultmsg = Resultmsg & strMsg & GetUseWUServer(dwValue) & VBCRLF

 If dwValue = "1" Then
  strMsg = "  - WSUS Server:  "
  strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate"
  strValueName = "WUServer"
  If RegValueExists(strKeyPath, strValueName) Then
   oReg.GetStringValue HKLM,strKeyPath,strValueName,strValue
   Resultmsg = Resultmsg & strMsg & strValue & VBCRLF
  Else
   Resultmsg = Resultmsg & strMsg & "Automatic Updates are not configured" & VBCRLF
  End If
 
  strMsg = "  - WU Status Server:  "
  strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate"
  strValueName = "WUStatusServer"
  If RegValueExists(strKeyPath, strValueName) Then
   oReg.GetStringValue HKLM,strKeyPath,strValueName,strValue
   Resultmsg = Resultmsg & strMsg & strValue & VBCRLF
  Else
   Resultmsg = Resultmsg & strMsg & "Automatic Updates are not configured" & VBCRLF
  End If
 Else
  Resultmsg = Resultmsg & VBCRLF
 End If
Else
 Resultmsg = Resultmsg & strMsg & "Automatic Updates are not configured" & VBCRLF
 Resultmsg = Resultmsg & "  - Client configured to receive Updates from windowsupdate.microsoft.com" & VBCRLF
End If

strMsg = "  - TargetGroup:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate"
strValueName = "TargetGroup"
 If RegValueExists(strKeyPath, strValueName) Then
  oReg.GetStringValue HKLM,strKeyPath,strValueName,strValue
  Resultmsg = Resultmsg & strMsg & strValue & VBCRLF & VBCRLF
 Else
  Resultmsg = Resultmsg & strMsg & "Value not configured" & VBCRLF & VBCRLF
End If

strMsg = "AU Options:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "AUOptions"
If RegValueExists(strKeyPath, strValueName) Then
 oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
 Resultmsg = Resultmsg & strMsg & GetAUOptions(dwValue) & VBCRLF

 If dwValue = "4" Then
  strMsg = "  - Scheduled Install Day:  "
  strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
  strValueName = "ScheduledInstallDay"
  If RegValueExists(strKeyPath, strValueName) Then
   oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
   Resultmsg = Resultmsg & strMsg & getday(dwValue) & VBCRLF
  Else
   Resultmsg = Resultmsg & strMsg & "Value not configured" & VBCRLF
  End If
 
  strMsg = "  - Planned Installation Time:  "
  strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
  strValueName = "ScheduledInstallTime"
  If RegValueExists(strKeyPath, strValueName) Then
   oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
   Resultmsg = Resultmsg & strMsg & dwValue &":00 - 24 hours 4:00 is 4 AM, 16:00 is 4 PM" & VBCRLF
  Else
   Resultmsg = Resultmsg & strMsg & "Value not configured" & VBCRLF
  End If
 Else
   Resultmsg = Resultmsg & VBCRLF
 End If

Else
 Resultmsg = Resultmsg & strMsg & "Value is not configured" & VBCRLF
 strMsg = "  - Benutzerdefinierte Einstellung:  "
 strKeyPath = "Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
 strValueName = "AUOptions"
 If RegValueExists(strKeyPath, strValueName) Then
  oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
  Resultmsg = Resultmsg & strMsg & GetAUOptions(dwValue) & VBCRLF

  If dwValue = "4" Then
   strMsg = "    - ScheduledInstallDay:  "
   strKeyPath = "Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
   strValueName = "ScheduledInstallDay"
   If RegValueExists(strKeyPath, strValueName) Then
    oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
    Resultmsg = Resultmsg & strMsg & getday(dwValue) & VBCRLF
   Else
    Resultmsg = Resultmsg & strMsg & "Automatic Updates are not configured" & VBCRLF
   End If
 
   strMsg = "    - ScheduledInstallTime:  "
   strKeyPath = "Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"
   strValueName = "ScheduledInstallTime"
   If RegValueExists(strKeyPath, strValueName) Then
    oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
    Resultmsg = Resultmsg & strMsg & dwValue &":00" & VBCRLF
   Else
    Resultmsg = Resultmsg & strMsg & "Automatic Updates are not configured" & VBCRLF
   End If
  Else
    Resultmsg = Resultmsg & VBCRLF
  End If

 Else
  Resultmsg = Resultmsg & strMsg & "Not configured" & VBCRLF
 End If
End If

strMsg = "  - NoAUShutdownOption:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "NoAUShutdownOption"
If RegValueExists(strKeyPath, strValueName) Then
 oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
 Resultmsg = Resultmsg & strMsg & GetNoAUShutdownOption(dwValue) & VBCRLF & VBCRLF
Else
 Resultmsg = Resultmsg & strMsg & "Value not configured" & VBCRLF & VBCRLF
End If

strMsg = "AutoInstallMinorUpdates:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "AutoInstallMinorUpdates"
If RegValueExists(strKeyPath, strValueName) Then
 oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
 Resultmsg = Resultmsg & strMsg & GetAutoInstallMinorUpdates(dwValue) & VBCRLF & VBCRLF
Else
 Resultmsg = Resultmsg & strMsg & "Value is not configured" & VBCRLF & VBCRLF
End If

strMsg = "DetectionFrequency:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "DetectionFrequency"
 If RegValueExists(strKeyPath, strValueName) Then
  oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
  Resultmsg = Resultmsg & strMsg &"Every " & dwValue &" Hours to search for updates"& VBCRLF
 Else
   Resultmsg = Resultmsg & strMsg & "Value is not configured"& VBCRLF
 End If

strMsg = "RebootRelaunchTimeout:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "RebootRelaunchTimeout"
 If RegValueExists(strKeyPath, strValueName) Then
  oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
  Resultmsg = Resultmsg & strMsg & dwValue &" Minutes to wait until system restart"& VBCRLF
 Else
   Resultmsg = Resultmsg & strMsg & "Value is not configured" & VBCRLF
 End If

strMsg = "RebootWarningTimeout:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "RebootWarningTimeout"
 If RegValueExists(strKeyPath, strValueName) Then
  oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
  Resultmsg = Resultmsg & strMsg & dwValue &" Minutes wait until system restart"& VBCRLF
 Else
   Resultmsg = Resultmsg & strMsg & "Value not configured" & VBCRLF
End If

strMsg = "NoAutoRebootWithLoggedOnUsers:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "NoAutoRebootWithLoggedOnUsers"
If RegValueExists(strKeyPath, strValueName) Then
 oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
 Resultmsg = Resultmsg & strMsg & GetNoAutoReboot(dwValue) & VBCRLF
Else
 Resultmsg = Resultmsg & strMsg & "Value not configured" & VBCRLF
 Resultmsg = Resultmsg & "  - Default: User will be presented with a 5 minutes countdown" & VBCRLF
End If

strMsg = "RescheduleWaitTime:  "
strKeyPath = "Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
strValueName = "RescheduleWaitTime"
If RegValueExists(strKeyPath, strValueName) Then
 oReg.GetDWORDValue HKLM,strKeyPath,strValueName,dwValue
 If dwValue = "0" Then Resultmsg = Resultmsg & strMsg & "Value not configured: " & dwValue & VBCRLF & VBCRLF End If
 If dwValue = "1" Then Resultmsg = Resultmsg & strMsg & dwValue &" Minute" & VBCRLF & VBCRLF End If
 If dwValue > "1" and dwValue < "61" Then Resultmsg = Resultmsg & strMsg & dwValue &" Minutes" & VBCRLF & VBCRLF End If
 If dwValue > "60" Then Resultmsg = Resultmsg & strMsg & "Invalid Value" & dwValue & VBCRLF & VBCRLF End If
Else
 Resultmsg = Resultmsg & strMsg & "Not Configured" & VBCRLF & VBCRLF
End If


Resultmsg = Resultmsg & "http://www.wsus.de" & VBCRLF & "Die Infoseite zu Windows Server Updates Services"

MsgBox Resultmsg,,strComputer

set oReg = nothing


Function GetNoAutoUpdate(Index)
 Select Case Index
  Case 0 GetNoAutoUpdate = "0 - Auto Update applied by GPO"
  Case 1 GetNoAutoUpdate = "1 - No Auto Update is applied by GPO"
  Case Else GetNoAutoUpdate = "Invalid Entry"
 End select
End Function

Function GetUseWUServer(Index)
 Select Case Index
  Case 0 GetUseWUServer = "0 - Client is configured to receive updates from windowsupdate.microsoft.com"
  Case 1 GetUseWUServer = "1 - Client is configured to receive updates from your WSUS Server"
  Case Else GetUseWUServer = "Invalid Entry"
 End select
End Function

Function GetDay(Index)
 Select Case Index
  Case "0" GetDay = "Every Day"
  Case "1" GetDay = "Every Sunday"
  Case "2" GetDay = "Every Monday"
  Case "3" GetDay = "Every Tuesday"
  Case "4" GetDay = "Every Wednesday"
  Case "5" GetDay = "Every Thursday"
  Case "6" GetDay = "Every Friday"
  Case "7" GetDay = "Every Saturday"
  Case Else GetDay = "Invalid Entry"
 End select
End Function

Function GetAUOptions(Index)
 Select Case Index
  Case "0" GetAUOptions = "0"
  Case "1" GetAUOptions = "1 - Deaktiviert in den Benutzereinstellungen"
  Case "2" GetAUOptions = "2 - Notify before download and Install."
  Case "3" GetAUOptions = "3 - Autom. Download, notify before installation."
  Case "4" GetAUOptions = "4 - Autom. Download, install according to GPO settings."
  Case "5" GetAUOptions = "5 - Allow Local Administator installation and manual configuration."
  case Else GetAUOptions = "Invalid Entry"
 End select
End Function

Function GetNoAUShutdownOption(Index)
 Select Case Index
  Case 0 GetNoAUShutdownOption = "0 - 'Updates are being installed and system will be restarted' user ill be notified"
  Case 1 GetNoAUShutdownOption = "1 - 'Updates are being installed and system will be restarted' user will NOT be notified"
  Case Else GetNoAUShutdownOption = "Invalid Entry"
 End select
End Function

Function GetAutoInstallMinorUpdates(Index)
 Select Case Index
  Case 0 GetAutoInstallMinorUpdates = "0 - Automatic updates are not immediately installed"
  Case 1 GetAutoInstallMinorUpdates = "1 - Automatic updates are immediately installed"
  Case Else GetAutoInstallMinorUpdates = "Invalid Entry"
 End select
End Function

Function GetNoAutoReboot(Index)
 Select Case Index
  Case "0" GetNoAutoReboot = "0 - User Countdown of 5 Minutes"
  Case "1" GetNoAutoReboot = "1 - User will be notified before a system restart"
  case Else GetNoAutoReboot = "Invalid Entry"
 End select
End Function

Function RegValueExists(sRegKey, sRegValue)
  sRegKey = Trim(sRegKey)
  sRegValue = LCase(Trim(sRegValue))
  ' init value
  RegValueExists = False
  If oReg.EnumValues(HKLM, sRegKey, aValueNames, aValueTypes) = 0 Then
    If Not IsNull(aValueNames) Then
      For i = 0 To UBound(aValueNames)
        If LCase(aValueNames(i)) = sRegValue Then
          RegValueExists = True
        End If
      Next
    End If
  End If
End Function

Function RegKeyExists(sRegKey)
  sRegKey = Trim(sRegKey)
  If oReg.EnumValues(HKLM, sRegKey, aValueNames, aValueTypes) = 0 Then
    RegKeyExists = True
  Else
    RegKeyExists = False
  End If
End Function