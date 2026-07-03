function Refresh-TDMData {
	Show-OverviewView
	$txtLog.Visible = $true
	
    Write-Log "========= TDM Toollists Update ========="

    $toollistsFile = Join-Path $baseTemp "toollists.json"
    $toolsFile     = Join-Path $baseTemp "tools.json"
	$assembliesFile   = Join-Path $baseTemp "assemblies.json"
	$machineToolsFile = Join-Path $baseTemp "machine_tools.json"

    $beforeToollists = if (Test-Path $toollistsFile) { (Get-Item $toollistsFile).LastWriteTime } else { $null }
    $beforeTools     = if (Test-Path $toolsFile)     { (Get-Item $toolsFile).LastWriteTime }     else { $null }
	$beforeassembliesFile     = if (Test-Path $assembliesFile)     { (Get-Item $assembliesFile).LastWriteTime }     else { $null }
	$beforemachineToolsFile     = if (Test-Path $machineToolsFile)     { (Get-Item $machineToolsFile).LastWriteTime }     else { $null }
    # scripts draaien
    & (Join-Path $tdmPath "toollists.ps1")

    Write-Log "========== TDM Tool Update =========="

    & (Join-Path $tdmPath "tools.ps1")
	
	Write-Log "========== TDM Assemblies Update =========="

	& (Join-Path $tdmPath "assemblies.ps1")

	Write-Log "========== Merge Tool Assemblies =========="

	& (Join-Path $tdmPath "merge.ps1")

    # check vernieuwd
    $updated = $true

    if (Test-Path $toollistsFile) {

        $after = (Get-Item $toollistsFile).LastWriteTime

        if ($beforeToollists -ne $null -and $after -le $beforeToollists) {
            Write-Log "⚠ toollists.json NIET vernieuwd"
            $updated = $false
        }
    }
    else {
        Write-Log "❌ toollists.json ontbreekt"
        $updated = $false
    }

    if (Test-Path $toolsFile) {

        $after = (Get-Item $toolsFile).LastWriteTime

        if ($beforeTools -ne $null -and $after -le $beforeTools) {
            Write-Log "⚠ tools.json NIET vernieuwd"
            $updated = $false
        }
    }
    else {
        Write-Log "❌ tools.json ontbreekt"
        $updated = $false
    }
	
	    if (Test-Path $assembliesFile) {

        $after = (Get-Item $assembliesFile).LastWriteTime

        if ($beforeassembliesFile -ne $null -and $after -le $beforeassembliesFile) {
            Write-Log "⚠ assemblies NIET vernieuwd"
            $updated = $false
        }
    }
    else {
        Write-Log "❌ assemblies.json ontbreekt"
        $updated = $false
    }
	
	    if (Test-Path $machineToolsFile) {

        $after = (Get-Item $machineToolsFile).LastWriteTime

        if ($beforemachineToolsFile -ne $null -and $after -le $beforemachineToolsFile) {
            Write-Log "⚠ machine_tools NIET vernieuwd"
            $updated = $false
        }
    }
    else {
        Write-Log "❌ machine_tools.json ontbreekt"
        $updated = $false
    }	
	

    if (-not $updated) {
        Write-Log "⚠️ TDM data NIET vernieuwd"
        return
    }
    else {
        Write-Log "✅ TDM data vernieuwd"
    }

    # data laden
    try {
        $script:data = Load-Data

        if ($data) {
            $script:resultData = $data.result.data
            $script:machine    = $data.result.machine
            $script:toolData   = $data.toollists
			$script:machineTools = $data.machineTools
        }
    }
    catch {
        Write-Log "REFRESH TDM FOUT: $_"
    }

    Write-Log "✅ Klaar"
	Start-Sleep -Seconds 3
	
	Build-Tree

if ($tree.SelectedNode) {
    Load-Details($tree.SelectedNode.Tag)
}
}
