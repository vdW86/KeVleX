function Register-Events {

    $dataGrid.add_Sorted({
        Apply-RowColors
    })

#    $dataGridLife.add_DataBindingComplete({
#        Apply-LifeColors
#    })

    $dataGridLife.add_Sorted({
        Apply-LifeColors
    })
	
	
	$dataGridLife.add_RowsAdded({
		Apply-LifeColors
	})


    $dataGrid.Add_SelectionChanged({

        if ($dataGrid.SelectedRows.Count -eq 0) {
            return
        }

        Show-Components
    })

    $tree.Add_AfterSelect({

        $node = $_.Node

        if ($node.Tag -eq "OVERVIEW") {

            foreach ($n in $tree.Nodes) {
                if ($n -ne $node) { $n.Collapse() }
            }

            Load-Details "OVERVIEW"
            return
        }

        if ($node.Parent -eq $null) {

            foreach ($n in $tree.Nodes) {
                if ($n -ne $node) { $n.Collapse() }
            }

            $node.Expand()
            Load-Details $null
            return
        }

        foreach ($n in $tree.Nodes) {
            if ($n -ne $node.Parent) { $n.Collapse() }
        }

        $node.Parent.Expand()
        Load-Details $node.Tag
    })
	
	$cboToolFilter.Add_SelectedIndexChanged({

    Apply-ToolFilter
})


$cboLifeFilter.Add_SelectedIndexChanged({

    Apply-LifeFilter
})


	$btnPrintTools.Add_Click({

		Print-Grid $dataGrid "KeVleX Tool Report"
	})
	
	$btnPrintLife.Add_Click({

		Print-Grid $dataGridLife "KeVleX Tool-Life Report"
	})

    $btnRefreshMach.Add_Click({
        Refresh-MachineData
    })

    $btnRefreshTDM.Add_Click({
        Refresh-TDMData
    })

    $btnCompare.Add_Click({
        Start-ToolCompare
    })
}