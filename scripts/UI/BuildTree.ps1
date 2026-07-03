# ================================
# TREE BUILD
# ================================
function Build-Tree {

    $tree.Nodes.Clear()

    $overview = New-Object System.Windows.Forms.TreeNode
    $overview.Text = "Overview"
    $overview.Tag  = "OVERVIEW"
    $tree.Nodes.Add($overview)

    $groups = @{}

    foreach ($item in $toolData) {

        $clean = $item.partname -replace "-NC\d+", ""

        if (-not $groups.ContainsKey($clean)) {
            $groups[$clean] = @()
        }

        $groups[$clean] += $item
    }

    foreach ($name in ($groups.Keys | Sort-Object)) {

        $parent = New-Object System.Windows.Forms.TreeNode
        $parent.Text = $name

        foreach ($item in ($groups[$name] | Sort-Object setup)) {
            $child = New-Object System.Windows.Forms.TreeNode
            $child.Text = $item.setup
            $child.Tag  = $item
            $parent.Nodes.Add($child)
        }

        $tree.Nodes.Add($parent)
    }

    $tree.SelectedNode = $tree.Nodes[0]
}