function Start-ToolCompare {

  & (Join-Path $tool_comparePath "Tool_p-Omzetten.ps1") 

    $selectedSetups = Select-Setups

    if (-not $selectedSetups -or $selectedSetups.Count -eq 0) {
        return
    }
    try {
	$unusedTools = & (Join-Path $tool_comparePath "ToolCompare.ps1") `
		-SelectedToollists $selectedSetups `
		-MachineToolsPath (Join-Path $baseTemp "tool_p.json") `
		-ResultData $resultData

        Show-UnusedTools $unusedTools
    }
    catch {
        Write-Log "COMPARE FOUT: $_"
    }
}
