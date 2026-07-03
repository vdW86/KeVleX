# ================================
# CONFIG
# ================================
$config = Get-Content ".\config.json" | ConvertFrom-Json

$ip      = $config.machine.ip
$tncPath = $config.machine.tncPath
$name    = $config.machine.name

$tool_t_remote = $config.paths.tool_t_remote
$tool_p_remote = $config.paths.tool_p_remote


# ================================
# NAAM OPSCHONEN (spaties eruit)
# ================================
$cleanName = $name -replace "\s+", ""

# ================================
# PAD OPBOUWEN
# ================================
$rootPath = "C:\TEMP"
$dataPath = Join-Path $rootPath $cleanName

$tool_t_local = Join-Path $dataPath "tool.t"
$tool_p_local = Join-Path $dataPath "tool_p.tch"


# ================================
# MAP STRUCTUUR MAKEN (zoals Excel)
# ================================
if (!(Test-Path $rootPath)) {
    Write-Host "📁 Maak: $rootPath"
    New-Item -ItemType Directory -Path $rootPath | Out-Null
}

if (!(Test-Path $dataPath)) {
    Write-Host "📁 Maak: $dataPath"
    New-Item -ItemType Directory -Path $dataPath | Out-Null
}


# ================================
# DOWNLOAD FUNCTIE (VBA STYLE)
# ================================
function Get-ToolFile {

    param (
        [string]$remote,
        [string]$local
    )

    Write-Host ""
    Write-Host "🔄 Ophalen: $remote"

    # EXACT zoals VBA
    $cmd = "`"$tncPath`" -i$ip `"get $remote $local`""

    Write-Host "CMD:"
    Write-Host $cmd
    Write-Host ""

    cmd /c $cmd

    Start-Sleep -Milliseconds 500

    if (Test-Path $local) {
        Write-Host "✅ OK: $local"
        return $true
    }
    else {
        Write-Host "❌ NIET gevonden: $local"
        return $false
    }
}


# ================================
# START
# ================================
Write-Host "===== TOOL FILES OPHALEN ====="

$r1 = Get-ToolFile $tool_t_remote $tool_t_local
$r2 = Get-ToolFile $tool_p_remote $tool_p_local

Write-Host ""

if ($r1 -and $r2) {
    Write-Host "✅ Alles succesvol opgehaald"
}
else {
    Write-Host "⚠️ Niet alles gelukt"
}

Write-Host "Klaar."