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
    $protocol = $row.Protocol
    $destinationPorts = @("$($row.DestinationPort)")

    if ($protocol -like "*ICMP*") {
        $protocols = @("ICMP")
        $destinationPorts = @("*")
    }
    else {
        $protocols = @($protocol)
    }

    $rules += [ordered]@{
        name                  = "{0}{1:D4}" -f $rulePrefix, $counter
        destination_addresses = @($row.DestinationIp)
        destination_ports     = $destinationPorts
        protocols             = $protocols
        source_addresses      = @($row.SourceIp)
    }

    $counter++
}

$rules | ConvertTo-Json -Depth 5 | Set-Content -Path $OutputJson -Encoding UTF8
