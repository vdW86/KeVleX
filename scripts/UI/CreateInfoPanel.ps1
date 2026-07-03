function New-InfoPanel {

	$lblTitle = New-Object System.Windows.Forms.Label
	$lblTitle.Text = "KeVleX Dashboard"
	$lblTitle.AutoSize = $true
	$lblTitle.Location = New-Object System.Drawing.Point(0,0)
	$lblTitle.ForeColor =
		[System.Drawing.Color]::FromArgb(0,120,215)

	$lblTitle.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    16,
    [System.Drawing.FontStyle]::Bold
)

    $infoPanel = New-Object System.Windows.Forms.Panel
    $infoPanel.Location = New-Object System.Drawing.Point(340,10)
    $infoPanel.Size = New-Object System.Drawing.Size(820,150)

    $form.Controls.Add($infoPanel)
	$infoPanel.Controls.Add($lblTitle)
	
	$picLogo = New-Object System.Windows.Forms.PictureBox
	$picLogo.Location = New-Object System.Drawing.Point(500,0)
	$picLogo.Size = New-Object System.Drawing.Size(128,128)
	$picLogo.SizeMode = "Zoom"

	$picLogo.Image = [System.Drawing.Image]::FromFile(
    (Join-Path $scriptBase "scripts\afbeeldingen\KeVleX.png")
	)	

$infoPanel.Controls.Add($picLogo)
	
    $lblInfo = New-Object System.Windows.Forms.Label
    $lblInfo.AutoSize = $true
    $lblInfo.Font = New-Object System.Drawing.Font("Consolas",10)
	$lblInfo.Location = New-Object System.Drawing.Point(0,35)
    $infoPanel.Controls.Add($lblInfo)

    $lblStatus = New-Object System.Windows.Forms.Label
    $lblStatus.AutoSize = $true
    $lblStatus.Location = New-Object System.Drawing.Point(0,110)
    $lblStatus.Font = New-Object System.Drawing.Font(
        "Segoe UI",
        11,
        [System.Drawing.FontStyle]::Bold
    )

    $infoPanel.Controls.Add($lblStatus)

    $buttonPanel = New-Object System.Windows.Forms.Panel
    $buttonPanel.Size = New-Object System.Drawing.Size(800,130)

    $infoPanel.Controls.Add($buttonPanel)

    $txtLog = New-Object System.Windows.Forms.TextBox
    $txtLog.Size = New-Object System.Drawing.Size(400,200)
    $txtLog.Multiline = $true
    $txtLog.ScrollBars = "Vertical"
    $txtLog.ReadOnly = $true

    $infoPanel.Controls.Add($txtLog)

    return @{
        InfoPanel   = $infoPanel
		LabelTitle  = $lblTitle
        LabelInfo   = $lblInfo
        LabelStatus = $lblStatus
        ButtonPanel = $buttonPanel
		Logo = $picLogo
        LogBox      = $txtLog
    }
}