function Show-OverviewView {

    $tabs.Visible = $false

  #  $txtLog.Visible = $true
	$txtLog.Visible = $false
    $buttonPanel.Visible = $true
}

function Show-DetailsView {

    $tabs.Visible = $true

    $txtLog.Visible = $false
    $buttonPanel.Visible = $false
}