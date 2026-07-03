function New-Tabs {
	
	
	$tabs = New-Object System.Windows.Forms.TabControl
    $tabs.Location = New-Object System.Drawing.Point(340,175)
    $tabs.Size = New-Object System.Drawing.Size(820,480)
	$tabs.BackColor = [System.Drawing.Color]::FromArgb(228,232,236)

	$tabs.Appearance = "Normal"

	
    $form.Controls.Add($tabs)
	
	# Tool-Info
    $tabTools = New-Object System.Windows.Forms.TabPage
    $tabTools.Text = "Tool-Info"
	$tabTools.BackColor      = [System.Drawing.Color]::FromArgb(228,232,236)
    $tabs.TabPages.Add($tabTools)

	# Tool-Life
    $tabLife = New-Object System.Windows.Forms.TabPage
    $tabLife.Text = "Tool-Life"
	$tabLife.BackColor       = [System.Drawing.Color]::FromArgb(228,232,236)
    $tabs.TabPages.Add($tabLife)

	# Components
    $tabComponents = New-Object System.Windows.Forms.TabPage
    $tabComponents.Text = "Components"
	$tabComponents.BackColor = [System.Drawing.Color]::FromArgb(228,232,236)
    $tabs.TabPages.Add($tabComponents)
	
	$cboToolFilter = New-Object System.Windows.Forms.ComboBox
	$cboToolFilter.Location = New-Object System.Drawing.Point(5,5)
	$cboToolFilter.Size = New-Object System.Drawing.Size(120,25)

	# Filter
	$cboToolFilter.Items.Add("All")
	$cboToolFilter.Items.Add("Groen")
	$cboToolFilter.Items.Add("Rood")
	$cboToolFilter.SelectedIndex = 0

	$tabTools.Controls.Add($cboToolFilter)
	
	$cboLifeFilter = New-Object System.Windows.Forms.ComboBox
	$cboLifeFilter.Location = New-Object System.Drawing.Point(5,5)
	$cboLifeFilter.Size = New-Object System.Drawing.Size(120,25)

	$cboLifeFilter.Items.Add("All")
	$cboLifeFilter.Items.Add("Groen")
	$cboLifeFilter.Items.Add("Oranje")
	$cboLifeFilter.Items.Add("Rood")

	$cboLifeFilter.SelectedIndex = 0

	$tabLife.Controls.Add($cboLifeFilter)
	
	$btnPrintTools = New-Object System.Windows.Forms.Button
	$btnPrintTools.Text = "Print"
	$btnPrintTools.Location = New-Object System.Drawing.Point(135,5)
	$btnPrintTools.Size = New-Object System.Drawing.Size(80,25)

	$tabTools.Controls.Add($btnPrintTools)

	$btnPrintLife = New-Object System.Windows.Forms.Button
	$btnPrintLife.Text = "Print"	
	$btnPrintLife.Location = New-Object System.Drawing.Point(135,5)
	$btnPrintLife.Size = New-Object System.Drawing.Size(80,25)

	$tabLife.Controls.Add($btnPrintLife)

    return @{
        Tabs           = $tabs
        ToolInfoTab    = $tabTools
        ToolLifeTab    = $tabLife
        ComponentsTab  = $tabComponents
		ToolFilter      = $cboToolFilter
		LifeFilter = $cboLifeFilter
		PrintButton    = $btnPrintTools
		PrintLifeButton = $btnPrintLife
    }

	
	
	
	
}