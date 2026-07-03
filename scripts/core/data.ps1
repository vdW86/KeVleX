# ================================
# DATA LOAD
# ================================
function Load-Data {

    $resultPath       = Join-Path $baseTemp "result.json"
    $toollistsPath    = Join-Path $baseTemp "toollists.json"
    $machineToolsPath = Join-Path $baseTemp "machine_tools.json"

    if (!(Test-Path $resultPath) -or !(Test-Path $toollistsPath)) {
        return $null
    }

    return [PSCustomObject]@{
        result       = Get-Content $resultPath -Raw | ConvertFrom-Json
        toollists    = Get-Content $toollistsPath -Raw | ConvertFrom-Json
        machineTools = if(Test-Path $machineToolsPath){
            Get-Content $machineToolsPath -Raw | ConvertFrom-Json
        }
        else {
            @()
        }
    }
}