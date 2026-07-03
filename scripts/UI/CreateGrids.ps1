function New-Grids {

    # Tool Info
    $dataGrid = New-Object System.Windows.Forms.DataGridView
    $dataGrid.Location = New-Object System.Drawing.Point(10,55)
    $dataGrid.Size = New-Object System.Drawing.Size(780,400)
    $dataGrid.ReadOnly = $true
    $dataGrid.RowHeadersVisible = $false
    $dataGrid.SelectionMode = "FullRowSelect"
    $dataGrid.MultiSelect = $false

    $tabTools.Controls.Add($dataGrid)

    # Tool Life
    $dataGridLife = New-Object System.Windows.Forms.DataGridView
    $dataGridLife.Location = New-Object System.Drawing.Point(10,55)
    $dataGridLife.Size = New-Object System.Drawing.Size(780,430)
    $dataGridLife.ReadOnly = $true
    $dataGridLife.RowHeadersVisible = $false

    $tabLife.Controls.Add($dataGridLife)

    # Components
    $dataGridComponents = New-Object System.Windows.Forms.DataGridView
    $dataGridComponents.Location = New-Object System.Drawing.Point(10,55)
    $dataGridComponents.Size = New-Object System.Drawing.Size(780,430)
    $dataGridComponents.ReadOnly = $true
    $dataGridComponents.RowHeadersVisible = $false
    $dataGridComponents.AllowUserToAddRows = $false
    $dataGridComponents.AllowUserToDeleteRows = $false

    $tabComponents.Controls.Add($dataGridComponents)

    return @{
        ToolGrid       = $dataGrid
        LifeGrid       = $dataGridLife
        ComponentsGrid = $dataGridComponents
    }
}