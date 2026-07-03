# ================================
# INIT
# ================================
$config = Get-Content ".\config.json" | ConvertFrom-Json

$machineName = $config.machine.name
$cleanName   = $machineName -replace "\s+", ""

$baseTemp = "C:\TEMP\$cleanName"

$toolPFile  = Join-Path $baseTemp "tool_p.tch"
$toolTFile  = Join-Path $baseTemp "tool.t"
$toolsJson  = Join-Path $baseTemp "tools.json"
$outputFile = Join-Path $baseTemp "result.json"


# ================================
# TOOL_P.TCH (AANWEZIG + POCKET + LOCK)
# ================================
Write-Host "🔄 TOOL_P..."

$machineTools = @{}

$usedPockets   = 0
$lockedPockets = 0

$lines = Get-Content $toolPFile -Encoding Default

# 🔍 header zoeken voor L positie
$headerLine = $lines | Where-Object { $_ -match "^\s*P\s+T\s+.*L\s+" } | Select-Object -First 1
$colL = $headerLine.IndexOf(" L ")

foreach ($line in $lines) {

    if ($line -match "^\d+") {

        # ======================
        # BESTAANDE LOGICA (NIET AANGEPAST)
        # ======================
        $parts = ($line -split "\s+") | Where-Object { $_ }

        if ($parts.Count -gt 0) {

            $pocket = $parts[0]

            if ($line -match "([1-9]\d{7})") {

                $toolId = $matches[1]
                $machineTools[$toolId] = $pocket
            }
        }

        # ======================
        # NIEUWE LOCK LOGICA
        # ======================
        $lockValue = ""

        if ($colL -ge 0 -and $line.Length -gt $colL) {
            $len = [Math]::Min(3, $line.Length - $colL)
            $lockValue = $line.Substring($colL, $len).Trim()
        }

        $isLocked = -not [string]::IsNullOrWhiteSpace($lockValue)

        if ($isLocked) {
            $lockedPockets++
        }
    }
}

$usedPockets = $machineTools.Count
$maxPockets  = $config.machine.max_pockets
$freePockets = $maxPockets - $usedPockets - $lockedPockets

Write-Host "✅ Machine tools:" $usedPockets
Write-Host "📊 Pockets:"
Write-Host "  Used   :" $usedPockets
Write-Host "  Locked :" $lockedPockets
Write-Host "  Free   :" $freePockets


# ================================
# TOOL.T (HEADER + FLEX PARSE)
# ================================
Write-Host "🔄 TOOL.T..."

$toolDetails = @{}

if (Test-Path $toolTFile) {

    $lines = Get-Content $toolTFile -Encoding Default

    $headerLine = $lines | Where-Object { $_ -match "TIME1" } | Select-Object -First 1

    if (-not $headerLine) {
        Write-Host "❌ Header niet gevonden"
        return
    }

    $fTime1 = $config.tool_fields.time1
    $fTime2 = $config.tool_fields.time2
    $fCur   = $config.tool_fields.current_time

    $columns = @{
        time1   = $headerLine.IndexOf($fTime1)
        time2   = $headerLine.IndexOf($fTime2)
        current = $headerLine.IndexOf($fCur)
    }

    Write-Host "✅ Kolommen:"
    $columns.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key) -> $($_.Value)"
    }

    foreach ($line in $lines) {

        if ($line.Length -lt 40) { continue }
        if ($line -notmatch "^\d+") { continue }

        $parts = ($line -split "\s+") | Where-Object { $_ }
        if ($parts.Count -lt 2) { continue }

        $toolId = $parts[1]

        if ($columns["time1"] -lt 0) { continue }

        $tail = $line.Substring($columns["time1"]).Trim()
        $vals = ($tail -split "\s+") | Where-Object { $_ }

        $time1   = if ($vals.Count -ge 1) { $vals[0] } else { "" }
        $time2   = if ($vals.Count -ge 2) { $vals[1] } else { "" }
        $current = if ($vals.Count -ge 3) { $vals[2] } else { "" }

        $toolDetails[$toolId] = @{
            time1        = $time1
            time2        = $time2
            current_time = $current
        }
    }

    Write-Host "✅ TOOL.T geladen:" $toolDetails.Count
}
else {
    Write-Host "⚠️ tool.t niet gevonden"
}


# ================================
# TOOLS.JSON
# ================================
$toolLists = Get-Content $toolsJson | ConvertFrom-Json


# ================================
# VERGELIJKEN
# ================================
Write-Host "🔄 Vergelijken..."

$result = @()

foreach ($list in $toolLists) {

    $toolResults = @()

    foreach ($tool in $list.tools) {

        $toolId = $tool.id

        $exists = $machineTools.ContainsKey($toolId)
        $pocket = if ($exists) { $machineTools[$toolId] } else { "" }

        $detail = $null
        if ($toolDetails.ContainsKey($toolId)) {
            $detail = $toolDetails[$toolId]
        }

        $toolResults += [PSCustomObject]@{
            tool_id  = $toolId
            name     = $tool.name
            aanwezig = $exists
            pocket   = $pocket

            time1        = if ($detail) { $detail.time1 } else { "" }
            time2        = if ($detail) { $detail.time2 } else { "" }
            current_time = if ($detail) { $detail.current_time } else { "" }
        }
    }

    $result += [PSCustomObject]@{
        toollist_id = $list.toollist_id
        tools       = $toolResults
    }
}


# ================================
# OPSLAAN
# ================================
Write-Host "💾 Opslaan..."

$final = [PSCustomObject]@{
    machine = @{
        total  = $maxPockets
        used   = $usedPockets
        locked = $lockedPockets
        free   = $freePockets
    }
    data = $result
}

$final | ConvertTo-Json -Depth 6 | Out-File $outputFile -Encoding UTF8

Write-Host "✅ Klaar"