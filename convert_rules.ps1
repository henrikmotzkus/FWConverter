param(
    [Parameter(Mandatory = $true)]
    [string]$InputCsv,

    [Parameter(Mandatory = $true)]
    [string]$OutputJson
)

$rulePrefix = "RuleLearner-20260305"

if (-not (Test-Path -Path $InputCsv)) {
    throw "Input CSV not found: $InputCsv"
}

$rows = Import-Csv -Path $InputCsv

$rules = @()
$counter = 1

foreach ($row in $rows) {
    $rules += [ordered]@{
        name                  = "{0}{1:D4}" -f $rulePrefix, $counter
        destination_addresses = @($row.DestinationIp)
        destination_ports     = @("$($row.DestinationPort)")
        protocols             = @($row.Protocol)
        source_addresses      = @($row.SourceIp)
    }

    $counter++
}

$rules | ConvertTo-Json -Depth 5 | Set-Content -Path $OutputJson -Encoding UTF8
