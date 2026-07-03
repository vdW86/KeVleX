function Get-VericutToolLife {

    param(
        [string]$ProgramName
    )

    $file = Get-VericutFile $ProgramName

    if (-not $file) {
        return @{}
    }

    $toolLife = @{}

    foreach ($line in Get-Content $file.FullName) {

        if ($line -match 'NAME:\s*\[(\d+)\].*LOSSOFLIFE:\s*\[(\d+)\]') {

            $toolId = $matches[1]
            $loss   = [int]$matches[2]

            if ($toolLife.ContainsKey($toolId)) {
                $toolLife[$toolId] += $loss
            }
            else {
                $toolLife[$toolId] = $loss
            }
        }
    }

    return $toolLife
}
function Get-VericutFile {

    param(
        [string]$ProgramName
    )

    if (-not (Test-Path $vericutTimesPath)) {
        return $null
    }

    Get-ChildItem $vericutTimesPath -File |
        Where-Object {
            $_.Name -like "$ProgramName*"
        } |
        Select-Object -First 1
}