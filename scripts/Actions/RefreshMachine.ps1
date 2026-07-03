function Refresh-MachineData {
	Show-OverviewView
	$txtLog.Visible = $true
# ================================
Write-Log "========= TOOL FILES OPHALEN ========="
# ================================
# Maak datum files vastleggen ter controle vernieuwing
# ================================
$toolPFile = Join-Path $baseTemp "tool_p.tch"
$toolTFile = Join-Path $baseTemp "tool.t"

$beforeToolP = if (Test-Path $toolPFile) { (Get-Item $toolPFile).LastWriteTime } else { $null }
$beforeToolT = if (Test-Path $toolTFile) { (Get-Item $toolTFile).LastWriteTime } else { $null }
# ================================
# Hier wordt een actie gestart met een Timeout
# ================================
	$job = Start-Job -ScriptBlock {
		param($path)
			& $path
		} -ArgumentList (Join-Path $MachPath "alatools.ps1")

	$finished = Wait-Job $job -Timeout $timeoutSec

		if ($finished) {
			Receive-Job $job | Out-Null
		}
		else {
			Stop-Job $job
				#Write-Log "alatools timeout na $timeoutSec seconden"
				Write-Log "⚠️ Machine timeout!"
		}
# ================================
# Controle of data vernieuwd is
# ================================
	$updated = $true

	# tool_p check
	if (Test-Path $toolPFile) {

		$after = (Get-Item $toolPFile).LastWriteTime

			if ($beforeToolP -ne $null -and $after -le $beforeToolP) {
			#	Write-Log "⚠ tool_p.tch NIET vernieuwd"
				$updated = $false
			}
	}
	else {
		Write-Log "❌ tool_p.tch ontbreekt na refresh"
			$updated = $false
	}

	# tool.t check
	if (Test-Path $toolTFile) {

		$after = (Get-Item $toolTFile).LastWriteTime

			if ($beforeToolT -ne $null -and $after -le $beforeToolT) {
			#	Write-Log "⚠ tool.t NIET vernieuwd"
				$updated = $false
			}
	}
	else {
		Write-Log "❌ tool.t ontbreekt na refresh"
		$updated = $false
	}

	if (-not $updated) {
		Write-Log "⚠️ Machine data NIET vernieuwd"
		Write-Log "⚠️ Oude machine data wordt gebruikt"
	}
	else {
		Write-Log "✅ Machine data vernieuwd"
	}
# ================================
#  Inladen van de gegevens
# ================================
	Write-Log "===== INLADEN TOOL_P.TCH & TOOL.T ====="
#================================
	& (Join-Path $MachPath "tool_p.ps1")
# ================================
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
        Write-Log "REFRESH MACHINE FOUT: $_"
    }

Build-Tree

if ($tree.SelectedNode) {
    Load-Details($tree.SelectedNode.Tag)
}
	
	Write-Log "✅ Klaar"
	Start-Sleep -Seconds 3
}
