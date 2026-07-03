function New-Tree {

    $tree = New-Object System.Windows.Forms.TreeView
    $tree.Location = New-Object System.Drawing.Point(10,10)
    $tree.Size = New-Object System.Drawing.Size(320,640)
	$tree.BackColor = [System.Drawing.Color]::WhiteSmoke
	$tree.BorderStyle = "FixedSingle"
    $form.Controls.Add($tree)

    return $tree
}