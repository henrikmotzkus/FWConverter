# FWConverter
UseCase: A rule in Azure firewall with an Any2Any setting needed to be eliminated. Based on actual traffic it is possible to generate the needed more specific rules.  

This tool is a small helper to convert CSV network flow rows into rule JSON objects matching the `ruletemplate.json` shape. Each CSV row becomes one rule with fields: `name`, `destination_addresses`, `destination_ports`, `protocols`, and `source_addresses`.

## Preparation
1. Create a CSV from querying the log analytics workspace. Query can be found in query.kql

## How the script works
- Reads an input CSV (see `query_data.csv` as an example).
- Builds a rule per row; `name` is prefixed with `RuleLearner-20260305` and a zero-padded counter (e.g., `RuleLearner-20260305` + `0001`).
- Emits an array of JSON objects to the specified output file.

### Getting the input CSV from Azure Firewall logs
1. Run the KQL in [query.kql](query.kql) against your Azure Firewall logs (e.g., Log Analytics workspace connected to Azure Firewall). It filters on the rule `in-hq-vpn-2-azure-private`, summarizes traffic, and orders by frequency.
2. Export the query results to CSV with headers `SourceIp,DestinationIp,Protocol,DestinationPort,count_` (matches [query_data.csv](query_data.csv)).
3. Feed that CSV to the script as shown below.

## Requirements
- PowerShell 5.1+ (or PowerShell 7+)
- Input CSV headers: `SourceIp,DestinationIp,Protocol,DestinationPort,count_`

## Usage
Run from the repo root:

```powershell
# Basic run
./convert_rules.ps1 -InputCsv query_data.csv -OutputJson rules.json

# With explicit paths
./convert_rules.ps1 -InputCsv "C:/path/to/input.csv" -OutputJson "C:/path/to/output.json"
```

## Notes
- The script throws if the input CSV path does not exist.
- Output uses UTF-8 encoding.

## Origin
This script was generated with GitHub Copilot using the following prompt:

> Create a powershell script. The script ingresses a file with csv structured data. a template can be found in file "query_data.csv". then it should create an output file. Output file should contain a json structure. A template of this JSON could be found in the file "ruletemplate.json". The rulename on the JSON object should consists of the prefix "RuleLearner-20260305" followed by a number that counts up for every rule.

## Tooling
- Model: GPT-5.1-Codex-Max (via GitHub Copilot)
- Editor: Visual Studio Code (latest stable as of 2026-03-05)
- Extension: GitHub Copilot extension enabled during authoring


## Evolving the script
Change the template files (csv and json) and prompt again. 
