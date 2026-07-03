# ================================
# INIT
# ================================
$config = Get-Content ".\config.json" | ConvertFrom-Json

# ================================
# MACHINE / PAD
# ================================
$machineName = $config.machine.name
$cleanName   = $machineName -replace "\s+", ""

$baseTemp   = "C:\TEMP\$cleanName"
$outputPath = Join-Path $baseTemp "toollists.json"

# ================================
# MAP MAKEN (zoals alatools)
# ================================
if (!(Test-Path $baseTemp)) {
    Write-Host "📁 Maak folder: $baseTemp"
    New-Item -ItemType Directory -Path $baseTemp | Out-Null
}

# ================================
# SQL CONFIG
# ================================
$connectionString = $config.database.connectionString

$query = @"
SELECT PARTNAME, LISTID, NCPROGRAM
FROM CIR_ORDER
WHERE MACHINEID = '$machineName'
"@

# ================================
# SQL CONNECTIE
# ================================
Write-Host "🔄 Ophalen toollijsten..."

$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString

try {
    $connection.Open()

    $command = $connection.CreateCommand()
    $command.CommandText = $query

    $reader = $command.ExecuteReader()

    $results = @()

    # NC parsing
    $regex = [regex]"NC0[1-9]|NC10"

    while ($reader.Read()) {

        $partname  = $reader["PARTNAME"]
        $listid    = $reader["LISTID"]
        $ncprogram = $reader["NCPROGRAM"]

        # ========================
        # SETUP BEPALEN
        # ========================
        $matches = $regex.Matches($ncprogram)
        $setup = ""

        if ($matches.Count -gt 0) {
            $setup = ($matches.Value -join "-")
        }

        # ========================
        # PARTNAME uitbreiden
        # ========================
        if ($setup -and ($partname -notlike "*$setup*")) {
            $partname = "$partname-$setup"
        }

        # ========================
        # OBJECT
        # ========================
        $results += [PSCustomObject]@{
            machine      = $machineName
            partname     = $partname
            toollist_id  = $listid
            nc_program   = $ncprogram
            setup        = $setup
        }
    }

    $reader.Close()
}
catch {
    Write-Host "❌ Fout bij SQL: $_"
}
finally {
    $connection.Close()
}

# ================================
# OPSLAAN
# ================================
Write-Host "💾 Opslaan..."

$results | ConvertTo-Json -Depth 3 | Out-File $outputPath -Encoding UTF8

Write-Host "✅ Klaar -> $outputPath"