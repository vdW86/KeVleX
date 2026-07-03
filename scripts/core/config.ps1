$configPath = Join-Path $scriptBase "config.json"
$config = Get-Content $configPath | ConvertFrom-Json

$vericutTimesPath = $config.paths.vericut_times
$machineName = $config.machine.name
$cleanName   = $machineName -replace "\s+", ""
$baseTemp = "C:\TEMP\$cleanName"

if (!(Test-Path $baseTemp)) {
    try {
        New-Item -ItemType Directory -Path $baseTemp -Force | Out-Null
    }
    catch {
        Write-Host "Fout bij aanmaken TEMP map: $baseTemp"
        return
    }
}

$logFile = Join-Path $baseTemp "KevleX.log"