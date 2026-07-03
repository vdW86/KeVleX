function New-Buttons {
	# Machine-Data
    $btnRefreshMach = New-Object System.Windows.Forms.Button
    $btnRefreshMach.Text = "⟳ Machine-Data"
    $btnRefreshMach.Size = New-Object System.Drawing.Size(120,25)
    $btnRefreshMach.Location = New-Object System.Drawing.Point(150,0)
	$btnRefreshMach.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
	$btnRefreshMach.ForeColor = [System.Drawing.Color]::White
	$btnRefreshMach.FlatStyle = "Flat"

    $buttonPanel.Controls.Add($btnRefreshMach)

	# TDM-Data
    $btnRefreshTDM = New-Object System.Windows.Forms.Button
    $btnRefreshTDM.Text = "⟳ TDM-Data"
    $btnRefreshTDM.Size = New-Object System.Drawing.Size(120,25)
    $btnRefreshTDM.Location = New-Object System.Drawing.Point(150,30)
	$btnRefreshTDM.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
	$btnRefreshTDM.ForeColor = [System.Drawing.Color]::White
	$btnRefreshTDM.FlatStyle  = "Flat"

    $buttonPanel.Controls.Add($btnRefreshTDM)

	# Tool-Compare
    $btnCompare = New-Object System.Windows.Forms.Button
    $btnCompare.Text = "Tool-Compare"
    $btnCompare.Size = New-Object System.Drawing.Size(120,25)
    $btnCompare.Location = New-Object System.Drawing.Point(150,60)
	$btnCompare.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
	$btnCompare.ForeColor = [System.Drawing.Color]::White
	$btnCompare.FlatStyle     = "Flat"
	
	
$btnRefreshMach.FlatAppearance.BorderColor = [System.Drawing.Color]::DodgerBlue
$btnRefreshTDM.FlatAppearance.BorderColor  = [System.Drawing.Color]::DodgerBlue
$btnCompare.FlatAppearance.BorderColor     = [System.Drawing.Color]::DodgerBlue

	
    $buttonPanel.Controls.Add($btnCompare)

    return @{
        RefreshMach = $btnRefreshMach
        RefreshTDM  = $btnRefreshTDM
        Compare     = $btnCompare
    }
}