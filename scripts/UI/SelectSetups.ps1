# ================================
# Tool-Compare
# ================================
function Select-Setups {

    $formSel = New-Object System.Windows.Forms.Form
    $formSel.Text = "Selecteer opspanningen"
    $formSel.Size = New-Object System.Drawing.Size(500,400)

    $treeSel = New-Object System.Windows.Forms.TreeView
    $treeSel.Dock = "Fill"
    $treeSel.CheckBoxes = $true

    $formSel.Controls.Add($treeSel)

    # ============================
    # GROEPEREN OP PARTNAME
    # ============================
    $groups = @{}

    foreach ($item in $toolData) {

        $pn = ($item.partname -replace "-NC\d+","")

        if (-not $groups.ContainsKey($pn)) {
            $groups[$pn] = @()
        }

        $groups[$pn] += $item
    }

    foreach ($pn in ($groups.Keys | Sort-Object)) {

        $parent = New-Object System.Windows.Forms.TreeNode
        $parent.Text = $pn

        foreach ($item in $groups[$pn]) {
            $child = New-Object System.Windows.Forms.TreeNode
            $child.Text = $item.setup
            $child.Tag  = $item
            $parent.Nodes.Add($child)
        }
	#	$parent.Expand()
        $treeSel.Nodes.Add($parent)
    }

    # ============================
    # OK BUTTON
    # ============================
    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Text = "OK"
    $btnOk.Dock = "Bottom"
    $formSel.Controls.Add($btnOk)

    $btnOk.Add_Click({

        $selectedItems = @()

        foreach ($parent in $treeSel.Nodes) {

            # ✅ als parent aangevinkt → alles meenemen
            if ($parent.Checked) {
                $selectedItems += foreach ($child in $parent.Nodes) {
                    $child.Tag
                }
            }
            else {
                # ✅ anders alleen children die aangevinkt zijn
                foreach ($child in $parent.Nodes) {
                    if ($child.Checked) {
                        $selectedItems += $child.Tag
                    }
                }
            }
        }

        $formSel.Tag = $selectedItems
        $formSel.Close()
    })

    $formSel.ShowDialog() | Out-Null
    return $formSel.Tag
}