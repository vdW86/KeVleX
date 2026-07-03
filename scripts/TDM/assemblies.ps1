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

$toolsPath     = Join-Path $baseTemp "tools.json"
$assembliesOut = Join-Path $baseTemp "assemblies.json"

# ================================
# SQL CONFIG
# ================================
$connectionString = $config.database.connectionString

# ================================
# CONTROL INPUT
# ================================
if (!(Test-Path $toolsPath)) {
    Write-Host "❌ tools.json niet gevonden"
    return
}

# ================================
# TOOLS LADEN
# ================================
Write-Host "🔄 Laden tools.json..."

$toolData = Get-Content $toolsPath | ConvertFrom-Json

$uniqueAssemblies = @()

foreach ($list in $toolData) {
    $uniqueAssemblies += $list.tools.id
}

$uniqueAssemblies = $uniqueAssemblies | Sort-Object -Unique

Write-Host "✅ Assemblies gevonden:" $uniqueAssemblies.Count

# ================================
# SQL
# ================================
$connection = New-Object System.Data.SqlClient.SqlConnection $connectionString

$allAssemblies = @()

try {

    $connection.Open()

    foreach ($assemblyId in $uniqueAssemblies) {

        Write-Host "🔧 Assembly:" $assemblyId

        $query = @"
SELECT
    t.toolid,
    t.name     AS AssemblyName,
    c.compid,
    c.name     AS ComponentName
FROM TDM_TOOL t
JOIN TDM_TOOLLIST tl
    ON t.toolid = tl.toolid
JOIN TDM_COMP c
    ON tl.compid = c.compid
WHERE t.toolid = 'A$assemblyId'
ORDER BY c.compid
"@

        $command = $connection.CreateCommand()
        $command.CommandText = $query

        $reader = $command.ExecuteReader()

        $assemblyName = $null
        $components = @()

        while ($reader.Read()) {

            if (-not $assemblyName) {
                $assemblyName = $reader["AssemblyName"]
            }

            $components += [PSCustomObject]@{
                component_id = $reader["compid"]
                name         = $reader["ComponentName"]
            }
        }

        $reader.Close()

        if ($assemblyName) {

            $allAssemblies += [PSCustomObject]@{
                assembly_id   = $assemblyId
                assembly_name = $assemblyName
                components    = $components
            }
        }
    }
}
catch {
    Write-Host "❌ SQL fout:"
    Write-Host $_
}
finally {
    $connection.Close()
}

# ================================
# OPSLAAN
# ================================
Write-Host "💾 Assemblies opslaan..."

$allAssemblies |
    ConvertTo-Json -Depth 10 |
    Out-File $assembliesOut -Encoding UTF8

Write-Host "✅ Klaar -> $assembliesOut"