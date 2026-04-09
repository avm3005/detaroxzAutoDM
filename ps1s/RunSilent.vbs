Set WshShell = CreateObject("WScript.Shell")
If WScript.Arguments.Count = 2 Then
    WshShell.Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File """ & WScript.Arguments(0) & """ -Theme " & WScript.Arguments(1), 0, False
Else
    WshShell.Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File """ & WScript.Arguments(0) & """", 0, False
End If
