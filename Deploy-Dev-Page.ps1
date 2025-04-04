Set-Location $PSScriptRoot

$ErrorActionPreference = "Stop"

$scpCommand = $( terraform output -raw "copy_temp_command_dev" )

Write-Host "SCP command is: $scpCommand"

Write-Host "Executing $scpCommand"

Invoke-Expression $scpCommand

$copyCommand = $( terraform output -raw "copy_nginx_dev" )

Write-Host "Copy command is: $copyCommand"

Write-Host "Executing command: $copyCommand"

Invoke-Expression $copyCommand

Write-Host "Blue (dev) page deployed successfully!" -ForegroundColor Green

exit 0
