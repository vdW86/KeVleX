function Initialize-Data {

    $requiredFiles = @(
        (Join-Path $baseTemp "result.json"),
        (Join-Path $baseTemp "toollists.json"),
        (Join-Path $baseTemp "machine_tools.json")
    )

    $missing = $requiredFiles | Where-Object {
        !(Test-Path $_) -or ((Get-Item $_).Length -eq 0)
    }

    if ($missing.Count -eq 0) {
        return
    }

	Write-Log "⚠ Eerste opstart of ontbrekende data gevonden"
    Write-Log "⚠ Initialisatie gestart"


    & (Join-Path $tdmPath "toollists.ps1")
    & (Join-Path $tdmPath "tools.ps1")
    & (Join-Path $tdmPath "assemblies.ps1")
    & (Join-Path $tdmPath "merge.ps1")
	& (Join-Path $MachPath "alatools.ps1")
    & (Join-Path $MachPath "tool_p.ps1")


    Write-Log "✅ Initialisatie gereed"
}