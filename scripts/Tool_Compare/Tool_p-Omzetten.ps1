# ================================
# CONFIG
# ================================
$config = Get-Content "config.json" | ConvertFrom-Json

$machineName = $config.machine.name
$cleanName   = $machineName -replace "\s+", ""
$baseTemp    = "C:\TEMP\$cleanName"

$input  = Join-Path $baseTemp "tool_p.tch"
$output = Join-Path $baseTemp "tool_p.json"

$lines = Get-Content $input

# ================================
# HEADER ZOEKEN
# ================================
$headerIndex = ($lines | Select-String "^\s*P\s+T\s+").LineNumber - 1
$header = $lines[$headerIndex]

# ================================
# KOLOM POSITIES (jouw logica)
# ================================
$colNames = @("P","T","ST","F","L","PLC","TNAME","DOC","PTYP")

$colStart = @{}

foreach ($name in $colNames) {
    $pos = $header.IndexOf($name)
    if ($pos -ge 0) {
        $colStart[$name] = $pos
    }
}

$sorted = $colStart.GetEnumerator() | Sort-Object Value

function Get-ColLength($name) {
    for ($i = 0; $i -lt $sorted.Count; $i++) {
        if ($sorted[$i].Key -eq $name) {

            $start = $sorted[$i].Value

            if ($i -lt ($sorted.Count - 1)) {
                $end = $sorted[$i+1].Value
            } else {
                $end = $header.Length
            }

            return ($end - $start)
        }
    }
}

$pStart = $colStart["P"]
$pLen   = Get-ColLength "P"

$tStart = $colStart["TNAME"]
$tLen   = Get-ColLength "TNAME"

# ================================
# DATA → JSON
# ================================
$result = @()

for ($i = $headerIndex + 1; $i -lt $lines.Count; $i++) {

    $line = $lines[$i]

    if ($line -match "END") { break }
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    if ($line.Length -lt $tStart) { continue }

    $pocket = $line.Substring($pStart, $pLen).Trim()
    $toolId = $line.Substring($tStart, $tLen).Trim()

    if (-not $toolId) { continue }

    $result += [PSCustomObject]@{
        tool_id = $toolId
        pocket  = $pocket
    }
}

# ================================
# OPSLAAN
# ================================
$result | ConvertTo-Json -Depth 3 | Set-Content $output

Write-Host "Klaar -> $output"