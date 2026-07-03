param(
    [Parameter(Mandatory=$true)]
    $SelectedToollists,

    [Parameter(Mandatory=$true)]
    $MachineToolsPath,

    [Parameter(Mandatory=$true)]
    $ResultData
)

# ================================
# MACHINE TOOLS (JSON)
# ================================
if (!(Test-Path $MachineToolsPath)) {
    throw "MachineTools JSON niet gevonden: $MachineToolsPath"
}

$machineTools = Get-Content $MachineToolsPath | ConvertFrom-Json

# pak tool_ids
$machineToolIds = $machineTools | ForEach-Object {
    $_.tool_id
} | Where-Object { $_ } | Sort-Object -Unique

# ================================
# SELECTED TOOLS
# ================================
$selectedToolIds = @()

foreach ($sel in $SelectedToollists) {

    if (-not $sel) { continue }

    $match = $ResultData | Where-Object {
        $_.toollist_id -eq $sel.toollist_id
    }

    if ($match -and $match.tools) {

        foreach ($tool in $match.tools) {

            if ($tool.tool_id) {
                $selectedToolIds += $tool.tool_id.ToString().Trim()
            }
        }
    }
}

$selectedToolIds = $selectedToolIds | Where-Object { $_ } | Sort-Object -Unique

# ================================
# COMPARE
# ================================
$unused = $machineToolIds | Where-Object {
    $_ -notin $selectedToolIds
}

# ================================
# RESULT (met pocket)
# ================================
$result = @()

foreach ($toolId in $unused) {

    $toolMachine = $machineTools | Where-Object {
        $_.tool_id -eq $toolId
    }

    # naam uit resultData zoeken
    $toolName = ""

    foreach ($tl in $ResultData) {
        $match = $tl.tools | Where-Object {
            $_.tool_id -eq $toolId
        }

        if ($match) {
            $toolName = $match.name
            break
        }
    }

    $result += [PSCustomObject]@{
        tool_id = $toolId
        name    = $toolName
        pocket  = $toolMachine.pocket
    }
}

return $result