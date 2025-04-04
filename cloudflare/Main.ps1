$ErrorActionPreference = "Stop"

$initialPath = $PSScriptRoot
$ParentFolder = Split-Path -Path $PSScriptRoot -Parent

Write-Host "Setting directory to $ParentFolder"

Set-Location $ParentFolder

$zoneName = "razumovsky.me"

$newDnsEntriesHashtable = @{ }

$gatewayIpAddress = terraform output -raw agwy_public_ip

$newDnsEntriesHashtable["agwy-vm-dev.$zoneName"] = $gatewayIpAddress
$newDnsEntriesHashtable["agwy-vm-qa.$zoneName"] = $gatewayIpAddress

Set-Location $initialPath

.\Upsert-CloudflareDnsRecord.ps1 `
    -ApiToken $env:CLOUDFLARE_API_KEY `
    -ZoneName $zoneName `
    -NewDnsEntriesHashtable $newDnsEntriesHashtable

Set-Location $ParentFolder