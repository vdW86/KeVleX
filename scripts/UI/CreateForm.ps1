function New-Form {

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "KeVleX"
    $form.Size = New-Object System.Drawing.Size(1000,700)
    $form.StartPosition = "CenterScreen"
	$form.BackColor = [System.Drawing.Color]::FromArgb(220,225,230)
	$form.Icon = New-Object System.Drawing.Icon(
		(Join-Path $scriptBase "scripts\afbeeldingen\KeVleX.ico")
	)
    return $form
}