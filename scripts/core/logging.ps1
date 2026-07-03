# ================================
# LOGGING
# ================================Get-UnusedTools
function Write-Log {
    param($msg)

    $timestamp = Get-Date -Format "HH:mm:ss"
    $line = "$timestamp - $msg"

    # naar bestand
    $line | Out-File $logFile -Append -Encoding UTF8

    # naar UI (als textbox bestaat)
    if ($txtLog) {
        $txtLog.AppendText($line + [Environment]::NewLine)
    }
}