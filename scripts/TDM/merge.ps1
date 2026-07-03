$config = Get-Content ".\config.json" | ConvertFrom-Json

$machineName = $config.machine.name
$cleanName   = $machineName -replace "\s+",""

$baseTemp = "C:\TEMP\$cleanName"

$toolsPath      = Join-Path $baseTemp "tools.json"
$assembliesPath = Join-Path $baseTemp "assemblies.json"
$outputPath     = Join-Path $baseTemp "machine_tools.json"

Write-Host "Laden bestanden..."

$tools      = Get-Content $toolsPath -Raw | ConvertFrom-Json
$assemblies = Get-Content $assembliesPath -Raw | ConvertFrom-Json

Write-Host "Assembly lookup bouwen..."

$assemblyLookup = @{}

foreach ($assembly in $assemblies) {
    $assemblyLookup[$assembly.assembly_id] = $assembly
}

Write-Host "Assemblies koppelen aan tools..."

foreach ($pocket in $tools) {

    foreach ($tool in $pocket.tools) {

        if ($assemblyLookup.ContainsKey($tool.id)) {

            $tool | Add-Member `
                -MemberType NoteProperty `
                -Name assembly_name `
                -Value $assemblyLookup[$tool.id].assembly_name `
                -Force

            $tool | Add-Member `
                -MemberType NoteProperty `
                -Name components `
                -Value $assemblyLookup[$tool.id].components `
                -Force
        }
    }
}

Write-Host "Opslaan..."

$tools |
    ConvertTo-Json -Depth 20 |
    Out-File $outputPath -Encoding UTF8

Write-Host "Gereed:"
Write-Host $outputPath