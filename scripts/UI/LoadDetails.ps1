function Load-Details($item) {

    # ============================
    # OVERVIEW
    # ============================
    if ($item -eq "OVERVIEW") {

        $lblInfo.Text = @"
Machine      : $($config.machine.name)

Totaal       : $($machine.total)
Bezet        : $($machine.used)
Geblokkeerd  : $($machine.locked)
Vrij         : $($machine.free)
"@

        $lblInfo.Refresh()

        $buttonPanel.Location = New-Object System.Drawing.Point(220,40)
        $buttonPanel.Visible = $true
        #$txtLog.Visible = $true

        $txtLog.Location = New-Object System.Drawing.Point(0, ($buttonPanel.Bottom + 10))
        $txtLog.BringToFront()

        $infoPanel.Height = $txtLog.Bottom + 10

		Show-OverviewView
        return
    }

    # ============================
    # BASIS UI VOOR DETAIL
    # ============================
	
	Show-DetailsView
	$tabs.BringToFront()
	
	# standaard naar Tool-Info
	$tabs.SelectedTab = $tabTools
	
    $txtLog.Visible = $false

    # ============================
    # PARTNAME (alle setups samen)
    # ============================
    if ($item -eq $null) {

        $parent = $tree.SelectedNode

        $allTools = @()

        foreach ($child in $parent.Nodes) {

            $dataSet = $resultData | Where-Object {
                $_.toollist_id -eq $child.Tag.toollist_id
            }

            if ($dataSet) {
                $allTools += $dataSet.tools
            }
        }


		# unieke tools
		$tools = $allTools | Sort-Object tool_id -Unique

		$total = $tools.Count

		# 🔥 missing berekenen
		$missingTools = $allTools | Where-Object { -not $_.aanwezig } | Select-Object -ExpandProperty tool_id -Unique
		$missing = $missingTools.Count
        $pn = $parent.Text

$lblInfo.Text = @"
Partname                   : $pn
Setup                      : ALL
Program                    : -
Toollist                   : -

Aantal Tools               : $total
Ontbrekende Tools          : $missing
Aantal Vrije plaatsen      : $($machine.free)
"@
    }
    else {

        # ============================
        # SETUP DETAIL
        # ============================

        $selected = $resultData | Where-Object {
            $_.toollist_id -eq $item.toollist_id
        }

        if (-not $selected) { return }

        $tools = $selected.tools | Sort-Object aanwezig

        $total   = $tools.Count
        $missing = ($tools | Where-Object { -not $_.aanwezig }).Count

        $pn = ($item.partname -replace "-NC\d+","")

        $lblInfo.Text = @"
Partname                   : $pn
Setup                      : $($item.setup)
Program                    : $($item.nc_program)
Toollist                   : $($item.toollist_id)

Aantal Tools               : $total
Ontbrekende Tools          : $missing
Aantal Vrije plaatsen      : $($machine.free)
"@
    }

    # ============================
    # TOOL GRID
    # ============================

    $table = New-Object System.Data.DataTable
    $table.Columns.Add("ToolID")
    $table.Columns.Add("Naam")
    $table.Columns.Add("Status")
    $table.Columns.Add("Pocket")

    foreach ($tool in $tools) {
        $row = $table.NewRow()
        $row["ToolID"] = $tool.tool_id
        $row["Naam"]   = $tool.name
        $row["Status"] = if ($tool.aanwezig) { "✅" } else { "❌" }
        $row["Pocket"] = $tool.pocket
        $table.Rows.Add($row)
    }

	$script:toolTable = $table
    $dataGrid.DataSource = $table
    $dataGrid.AutoResizeColumns()
    $dataGrid.AutoSizeColumnsMode = "DisplayedCells"
    Apply-RowColors


$vericutLife = @{}

if ($item -ne $null) {
    $vericutLife = Get-VericutToolLife $item.nc_program
}


    # ============================
    # LIFE GRID
    # ============================

    $tableLife = New-Object System.Data.DataTable
    $tableLife.Columns.Add("ToolID")
    $tableLife.Columns.Add("Naam")
    $tableLife.Columns.Add("TIME1",[int])
    $tableLife.Columns.Add("TIME2",[int])
    $tableLife.Columns.Add("CUR.TIME",[int])
	$tableLife.Columns.Add("VERICUT.TIME",[int])
	$tableLife.Columns.Add("FILTER")

    foreach ($tool in $tools) {
        $row = $tableLife.NewRow()
        $row["ToolID"] = $tool.tool_id
        $row["Naam"]   = $tool.name
        $row["TIME1"]  = [int]$tool.time1
		$row["TIME2"]  = [int]$tool.time2
        $row["CUR.TIME"] = [int]$tool.current_time
		
		
    $toolId = "$($tool.tool_id)"

    if ($vericutLife.ContainsKey($toolId)) {

		$row["VERICUT.TIME"] = [math]::Ceiling(
		$vericutLife[$toolId] / 60
		)

    }
    else {

        $row["VERICUT.TIME"] = 0
    }
		
        $tableLife.Rows.Add($row)
    }

	$script:lifeTable = $tableLife
    $dataGridLife.DataSource = $tableLife
	$dataGridLife.Columns["FILTER"].Visible = $false
    $dataGridLife.AutoResizeColumns()
    $dataGridLife.AutoSizeColumnsMode = "DisplayedCells"
	$form.BeginInvoke({
		Apply-LifeColors
	})

	
	# ============================
	# COMPONENT GRID
	# ============================
if ($dataGrid.Rows.Count -gt 0) {
    $dataGrid.Rows[0].Selected = $true
    Show-Components
}
	Apply-LifeColors
	
    # ============================
    # LAYOUT FIX
    # ============================

    $infoPanel.Height = $lblInfo.Bottom + 10
}
	function Show-Components {

    if ($dataGrid.SelectedRows.Count -eq 0) {
        return
    }

    $selectedToolId = "$($dataGrid.SelectedRows[0].Cells['ToolID'].Value)"

    $tableComp = New-Object System.Data.DataTable
    $tableComp.Columns.Add("ComponentID")
    $tableComp.Columns.Add("Component")

    # NC niveau
    if ($tree.SelectedNode.Tag -and $tree.SelectedNode.Tag.toollist_id) {

        $toolAssemblyData = $machineTools |
            Where-Object {
                $_.toollist_id -eq $tree.SelectedNode.Tag.toollist_id
            } |
            Select-Object -First 1

        if ($toolAssemblyData) {

            $assembly = $toolAssemblyData.tools |
                Where-Object {
                    "$($_.id)" -eq $selectedToolId
                } |
                Select-Object -First 1

            if ($assembly) {

                foreach ($component in $assembly.components) {

                    $row = $tableComp.NewRow()

                    $row["ComponentID"] = $component.component_id
                    $row["Component"]   = $component.name

                    $tableComp.Rows.Add($row)
                }
            }
        }
    }

    # Partname niveau
    else {

        foreach ($child in $tree.SelectedNode.Nodes) {

            $toolAssemblyData = $machineTools |
                Where-Object {
                    $_.toollist_id -eq $child.Tag.toollist_id
                } |
                Select-Object -First 1

            if (-not $toolAssemblyData) {
                continue
            }

            $assembly = $toolAssemblyData.tools |
                Where-Object {
                    "$($_.id)" -eq $selectedToolId
                } |
                Select-Object -First 1

            if (-not $assembly) {
                continue
            }

            foreach ($component in $assembly.components) {

                $row = $tableComp.NewRow()

                $row["ComponentID"] = $component.component_id
                $row["Component"]   = $component.name

                $tableComp.Rows.Add($row)
            }

            break
        }
    }

    $dataGridComponents.DataSource = $tableComp
    $dataGridComponents.AutoResizeColumns()
    $dataGridComponents.AutoSizeColumnsMode = "DisplayedCells"
}
function Apply-ToolFilter {

    if (-not $script:toolTable) {
        return
    }

    $view = New-Object System.Data.DataView($script:toolTable)

    switch ($cboToolFilter.Text) {

        "Groen" {
            $view.RowFilter = "Status = '✅'"
        }

        "Rood" {
            $view.RowFilter = "Status = '❌'"
        }

        default {
            $view.RowFilter = ""
        }
    }

    $dataGrid.DataSource = $view

    Apply-RowColors
}

function Apply-LifeFilter {

    if (-not $script:lifeTable) {
        return
    }

    $view = New-Object System.Data.DataView($script:lifeTable)

    switch ($cboLifeFilter.Text) {

        "Groen" {
            $view.RowFilter = "FILTER = 'Groen'"
        }

        "Oranje" {
            $view.RowFilter = "FILTER = 'Oranje'"
        }

        "Rood" {
            $view.RowFilter = "FILTER = 'Rood'"
        }

        default {
            $view.RowFilter = ""
        }
    }

    $dataGridLife.DataSource = $view
	Apply-LifeColors
}

function Print-Grid {

    param(
        $Grid,
        [string]$Title
    )

    $html = @"
<html>
<head>
<style>
table {
    border-collapse: collapse;
    font-family: Consolas;
}

th, td {
    border: 1px solid black;
    padding: 4px;
}

th {
    background-color: #DDE5EE;
}
</style>

<script>
window.onload = function() {
    window.print();
}
</script>

</head>
<body>

<h2>$Title</h2>

<table>
<tr>
"@


	foreach ($col in $Grid.Columns) {

		if (-not $col.Visible) {
			continue
		}

			$html += "<th>$($col.HeaderText)</th>"
	}


$html += "</tr>"

$visibleColumns = @()

foreach ($col in $Grid.Columns) {

    if ($col.Visible) {
        $visibleColumns += $col
    }
}

foreach ($row in $Grid.Rows) {

    if ($row.IsNewRow) {
        continue
    }

    $html += "<tr>"

    foreach ($col in $visibleColumns) {

        $html += "<td>$($row.Cells[$col.Index].Value)</td>"
    }

    $html += "</tr>"
}


    $html += @"
</table>

</body>
</html>
"@

    $reportFile = Join-Path $env:TEMP "KeVleX_Report.html"

    $html | Set-Content $reportFile -Encoding UTF8

    Start-Process msedge.exe $reportFile
}