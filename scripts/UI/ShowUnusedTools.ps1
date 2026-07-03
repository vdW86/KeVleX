# ================================
# Tool-Compare
# ================================
function Show-UnusedTools($unusedTools) {

    $formRes = New-Object System.Windows.Forms.Form
    $formRes.Text = "Ongebruikte Tools"
    $formRes.Size = New-Object System.Drawing.Size(800,500)

    # LABEL
    $lblCount = New-Object System.Windows.Forms.Label
    $lblCount.AutoSize = $true
    $lblCount.Location = New-Object System.Drawing.Point(10,10)
    $lblCount.Text = "Aantal tools: $($unusedTools.Count)"
    $formRes.Controls.Add($lblCount)

    # PRINT BUTTON
    $btnPrint = New-Object System.Windows.Forms.Button
    $btnPrint.Text = "Print"
    $btnPrint.Location = New-Object System.Drawing.Point(650,10)
    $btnPrint.Size = New-Object System.Drawing.Size(100,30)
    $formRes.Controls.Add($btnPrint)

    # GRID
    $grid = New-Object System.Windows.Forms.DataGridView
    $grid.Location = New-Object System.Drawing.Point(10,40)
    $grid.Size = New-Object System.Drawing.Size(760,400)
    $grid.ReadOnly = $true
    $grid.RowHeadersVisible = $false
    $formRes.Controls.Add($grid)

    # TABLE
    $table = New-Object System.Data.DataTable
    $table.Columns.Add("ToolID")
    $table.Columns.Add("Naam")
    $table.Columns.Add("Pocket")

    foreach ($tool in $unusedTools) {
        $row = $table.NewRow()
        $row["ToolID"] = $tool.tool_id
        $row["Naam"]   = $tool.name
        $row["Pocket"] = $tool.pocket
        $table.Rows.Add($row)
    }

    $grid.DataSource = $table

    # ============================
    # PRINT LOGICA ✅ HIER
    # ============================
    $printDoc = New-Object System.Drawing.Printing.PrintDocument
    $printFont = New-Object System.Drawing.Font("Consolas",10)

$printDoc.Add_PrintPage({

    param($sender, $e)

    $y = 20

    # ============================
    # TITEL
    # ============================
    $title = "Ongebruikte Tools Overzicht"
    $e.Graphics.DrawString($title, $printFont, [System.Drawing.Brushes]::Black, 20, $y)
    $y += 25

    # ============================
    # AANTAL
    # ============================
    $countLine = "Aantal tools die verwijderd kunnen worden: $($unusedTools.Count)"
    $e.Graphics.DrawString($countLine, $printFont, [System.Drawing.Brushes]::Black, 20, $y)
    $y += 25

    # ============================
    # HEADER
    # ============================
    $header = "{0,-12} | {1,-45} | {2,6}" -f "ToolID","Naam","Pocket"
    $e.Graphics.DrawString($header, $printFont, [System.Drawing.Brushes]::Black, 20, $y)
    $y += 20

    # ============================
    # SCHEIDINGSLIJN
    # ============================
    $lineSep = "-" * 75
    $e.Graphics.DrawString($lineSep, $printFont, [System.Drawing.Brushes]::Black, 20, $y)
    $y += 20

    # ============================
    # DATA
    # ============================
    foreach ($tool in $unusedTools) {

        $line = "{0,-12} | {1,-45} | {2,6}" -f $tool.tool_id, $tool.name, $tool.pocket
        $e.Graphics.DrawString($line, $printFont, [System.Drawing.Brushes]::Black, 20, $y)

        $y += 20

        if ($y -gt 800) {
            $e.HasMorePages = $true
            return
        }
    }
})

    # PRINT BUTTON CLICK
    $btnPrint.Add_Click({

        $dialog = New-Object System.Windows.Forms.PrintDialog
        $dialog.Document = $printDoc

        if ($dialog.ShowDialog() -eq "OK") {
            $printDoc.Print()
        }
    })

    # ============================
    # EINDE
    # ============================
    $formRes.ShowDialog()
}