Set objShell = CreateObject("WScript.Shell")

objShell.Run """C:\Program Files\PowerShell\7\pwsh.exe"" -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""C:\TEMP\KeVleX\KeVleX.ps1""", 0, False