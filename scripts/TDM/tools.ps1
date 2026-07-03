# ================================
# INIT
# ================================
$config = Get-Content ".\config.json" | ConvertFrom-Json

# ================================
# MACHINE / PAD
# ================================
$machineName = $config.machine.name
$cleanName   = $machineName -replace "\s+", ""

$baseTemp = "C:\TEMP\$cleanName"

$toollistsPath = Join-Path $baseTemp "toollists.json"
$outputPath    = Join-Path $baseTemp "tools.json"

# ================================
# SQL CONFIG
# ================================
$connectionString = $config.database.connectionString


# ================================
# CONTROL INPUT
# ================================
if (!(Test-Path $toollistsPath)) {
    Write-Host "❌ toollists.json niet gevonden:"
    Write-Host "   $toollistsPath"
    return
}

# ================================
# DATA LADEN
# ================================
Write-Host "🔄 Laden toollists..."

$toollists = Get-Content $toollistsPath | ConvertFrom-Json

$uniqueLists = $toollists.toollist_id | Sort-Object -Unique

Write-Host "✅ Aantal unieke toollists:" $uniqueLists.Count


# ================================
# SQL CONNECTIE
# ================================
$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString

try {
    $connection.Open()

    Write-Host "🔄 Ophalen tools uit SQL..."

    $allResults = @()

    foreach ($listid in $uniqueLists) {

        Write-Host "🔧 Processing:" $listid

        $query = @"
SELECT fs, LISTID,
CASE WHEN fs = 'A' THEN toolid ELSE compid END AS ID,
NAME
FROM (
    SELECT 'A' AS fs, l.listid, t.toolid, NULL AS compid, t.name
    FROM TDM_LIST l
    JOIN TDM_LISTLISTB ll ON l.listid = ll.listid
    JOIN TDM_TOOL t ON ll.toolid = t.toolid
    WHERE l.listid = '$listid'

    UNION ALL

    SELECT 'B', l.listid, t.toolid, c.compid, c.name
    FROM TDM_LIST l
    JOIN TDM_LISTLISTB ll ON l.listid = ll.listid
    JOIN TDM_TOOL t ON ll.toolid = t.toolid
    JOIN TDM_TOOLLIST tl ON t.toolid = tl.toolid
    JOIN TDM_COMP c ON tl.compid = c.compid
    WHERE l.listid = '$listid'
) AS Combined
ORDER BY listid, toolid, fs
"@

        $command = $connection.CreateCommand()
        $command.CommandText = $query

        $reader = $command.ExecuteReader()

        $tools = @()

        while ($reader.Read()) {

            if ($reader["fs"] -eq "A") {

                $tools += [PSCustomObject]@{
                    id   = ($reader["ID"].ToString()).Substring(1)
                    name = $reader["NAME"]
                }
            }
        }

        $reader.Close()

        $allResults += [PSCustomObject]@{
            toollist_id = $listid
            tools       = $tools
        }
    }
}
catch {
    Write-Host "❌ SQL fout: $_"
}
finally {
    $connection.Close()
}

# ================================
# OPSLAAN
# ================================
Write-Host "💾 Opslaan..."

$allResults | ConvertTo-Json -Depth 5 | Out-File $outputPath -Encoding UTF8

Write-Host "✅ Klaar -> $outputPath"