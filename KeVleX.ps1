Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ================================
# BASE + CONFIG
# ================================
$ErrorActionPreference = "Stop"
$scriptBase  = Split-Path -Parent $PSCommandPath

$scriptsPath = Join-Path $scriptBase "scripts"
$tdmPath = Join-Path $scriptsPath "TDM"
$tool_comparePath = Join-Path $scriptsPath "Tool_Compare"
$MachPath = Join-Path $scriptsPath "Mach"

# core
. (Join-Path $scriptsPath "core\config.ps1")
. (Join-Path $scriptsPath "core\logging.ps1")
. (Join-Path $scriptsPath "core\data.ps1")
. (Join-Path $scriptsPath "core\InitializeData.ps1")
. (Join-Path $scriptsPath "core\VericutTimes.ps1")

# UI
. (Join-Path $scriptsPath "UI\BuildTree.ps1")
. (Join-Path $scriptsPath "UI\SelectSetups.ps1")
. (Join-Path $scriptsPath "UI\ShowUnusedTools.ps1")
. (Join-Path $scriptsPath "UI\LoadDetails.ps1")
. (Join-Path $scriptsPath "UI\Colors.ps1")
. (Join-Path $scriptsPath "UI\Buttons.ps1")
. (Join-Path $scriptsPath "UI\CreateTabs.ps1")
. (Join-Path $scriptsPath "UI\CreateGrids.ps1")
. (Join-Path $scriptsPath "UI\RegisterEvents.ps1")
. (Join-Path $scriptsPath "UI\CreateInfoPanel.ps1")
. (Join-Path $scriptsPath "UI\CreateForm.ps1")
. (Join-Path $scriptsPath "UI\CreateTree.ps1")
. (Join-Path $scriptsPath "UI\ViewHelpers.ps1")

# Actions
. (Join-Path $scriptsPath "Actions\RefreshMachine.ps1")
. (Join-Path $scriptsPath "Actions\RefreshTDM.ps1")
. (Join-Path $scriptsPath "Actions\RunCompare.ps1")

$timeoutSec = $config.settings.timeout_sec

# ================================
# INITIALIZE DATA
# ================================
Initialize-Data

# ================================
# DATA LOAD
# ================================
try {
    $data = Load-Data

    if ($data) {
        $resultData = $data.result.data
        $machine    = $data.result.machine
        $toolData   = $data.toollists
		$machineTools = $data.machineTools
    }
    else {
        throw "Data is null"
    }
}
catch {
    Write-Log "START FOUT: $_"
    $resultData = @()
    $machine    = $null
    $toolData   = @()
}

# ================================
# FORM
# ================================
$form = New-Form

# ================================
# TREEVIEW
# ================================
$tree = New-Tree

# ================================
# INFO PANEL
# ================================
$panelData = New-InfoPanel

$infoPanel   = $panelData.InfoPanel
$lblTitle    = $panelData.LabelTitle
$lblInfo     = $panelData.LabelInfo
$lblStatus   = $panelData.LabelStatus
$buttonPanel = $panelData.ButtonPanel
$txtLog      = $panelData.LogBox

# ================================
# BUTTONS
# ================================
$buttons = New-Buttons
$btnRefreshMach = $buttons.RefreshMach
$btnRefreshTDM  = $buttons.RefreshTDM
$btnCompare     = $buttons.Compare

# ================================
# TABS
# ================================
$tabData = New-Tabs
$tabs          = $tabData.Tabs
$tabTools      = $tabData.ToolInfoTab
$tabLife       = $tabData.ToolLifeTab
$tabComponents = $tabData.ComponentsTab
$cboToolFilter = $tabData.ToolFilter
$btnPrintTools = $tabData.PrintButton
$btnPrintLife = $tabData.PrintLifeButton
$cboLifeFilter = $tabData.LifeFilter
# ================================
# GRIDS
# ================================
$gridData = New-Grids
$dataGrid           = $gridData.ToolGrid
$dataGridLife       = $gridData.LifeGrid
$dataGridComponents = $gridData.ComponentsGrid

# ================================
# EVENTS
# ================================
Register-Events
# ================================
# START
# ================================
Build-Tree
[void]$form.ShowDialog()