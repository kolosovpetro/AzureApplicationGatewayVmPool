# Azure Application Gateway with Linux VMS backend

## Provision commands

- terraform plan
- terraform apply
- .\Deploy-Dev-Page.ps1
- .\Deploy-Qa-Page.ps1

## DNS

- http://agwy-vm-dev.razumovsky.me (should redirect to blue)
- https://agwy-vm-dev.razumovsky.me (blue)
- http://agwy-vm-qa.razumovsky.me (should redirect to green)
- https://agwy-vm-qa.razumovsky.me (green)

## Certificates

- https://certifytheweb.com/
- https://www.win-acme.com/