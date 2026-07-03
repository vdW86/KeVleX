# ================================
# COLORS Tools-Info
# ================================
function Apply-RowColors {

    foreach ($row in $dataGrid.Rows) {

        if ($row.Cells["Status"].Value -eq "❌") {
            $row.DefaultCellStyle.BackColor = "LightCoral"
        }
        else {
            $row.DefaultCellStyle.BackColor = "LightGreen"
        }
    }
}

# ================================
# COLORS Tool-Life
# ================================
function Apply-LifeColors {

    foreach ($row in $dataGridLife.Rows) {

        $cur = [double]($row.Cells["CUR.TIME"].Value)

        $vericut = 0

        if ($row.Cells["VERICUT.TIME"].Value) {
            $vericut = [double]($row.Cells["VERICUT.TIME"].Value)
        }

        # ============================
        # MET VERICUT
        # ============================
        if ($vericut -gt 0) {

            $max = [double]($row.Cells["TIME1"].Value)

            if ($max -le 0) {
                $row.DefaultCellStyle.ForeColor = "Gray"
                continue
            }

            $usage = (($cur + $vericut) / $max) * 100
        }

        # ============================
        # ZONDER VERICUT
        # ============================
        else {

            $max = [double]($row.Cells["TIME2"].Value)

            if ($max -le 0) {
                $row.DefaultCellStyle.ForeColor = "Gray"
                continue
            }

            $usage = ($cur / $max) * 100
        }

        # ============================
        # KLEUREN + FILTER
        # ============================
        if ($usage -gt 100) {

            $row.Cells["FILTER"].Value = "Rood"

            $row.DefaultCellStyle.BackColor = "Red"
            $row.DefaultCellStyle.ForeColor = "White"
        }
        elseif ($usage -ge 70) {

            $row.Cells["FILTER"].Value = "Oranje"

            $row.DefaultCellStyle.BackColor = "Orange"
            $row.DefaultCellStyle.ForeColor = "Black"
        }
        else {

            $row.Cells["FILTER"].Value = "Groen"

            $row.DefaultCellStyle.BackColor = "MediumSeaGreen"
            $row.DefaultCellStyle.ForeColor = "Black"
        }
    }
}