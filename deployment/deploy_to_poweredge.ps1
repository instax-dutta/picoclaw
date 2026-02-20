<#
.SYNOPSIS
    Deploys picoclaw to a remote server.

.DESCRIPTION
    This script transfers the source code to a remote server, builds the application,
    and sets up a systemd service for production deployment.

.PARAMETER remoteHost
    The IP address or hostname of the remote server. Can also be set via $env:REMOTE_HOST.

.PARAMETER remoteUser
    The username for SSH connection to the remote server. Can also be set via $env:REMOTE_USER.

.PARAMETER remoteDir
    The target directory on the remote server. Defaults to ~/picoclaw.

.EXAMPLE
    .\deploy_to_poweredge.ps1 -remoteHost 192.168.1.100 -remoteUser myuser

.EXAMPLE
    $env:REMOTE_HOST = "192.168.1.100"
    $env:REMOTE_USER = "myuser"
    .\deploy_to_poweredge.ps1
#>

param(
    [Parameter()]
    [string]$remoteHost = "",

    [Parameter()]
    [string]$remoteUser = "",

    [Parameter()]
    [string]$remoteDir = "~/picoclaw"
)

if (-not $remoteHost) {
    $remoteHost = $env:REMOTE_HOST
}

if (-not $remoteUser) {
    $remoteUser = $env:REMOTE_USER
}

if (-not $remoteHost -or -not $remoteUser) {
    Write-Host "Error: Remote host and user are required." -ForegroundColor Red
    Write-Host ""
    Write-Host "Usage: .\deploy_to_poweredge.ps1 -remoteHost <hostname/ip> -remoteUser <username> [-remoteDir <directory>]"
    Write-Host ""
    Write-Host "Alternatively, set environment variables:"
    Write-Host "  `$env:REMOTE_HOST = 'hostname'"
    Write-Host "  `$env:REMOTE_USER = 'username'"
    exit 1
}

Write-Host "Deploying to $remoteUser@$remoteHost..." -ForegroundColor Cyan
Write-Host "Target directory: $remoteDir"
Write-Host ""

Write-Host "Creating remote directory..."
ssh $remoteUser@$remoteHost "mkdir -p $remoteDir"

Write-Host "Transferring files..."
scp -r cmd pkg go.mod go.sum $remoteUser@$remoteHost:$remoteDir/

scp deployment/config.json $remoteUser@$remoteHost:$remoteDir/config.json
scp deployment/.env $remoteUser@$remoteHost:$remoteDir/.env
scp deployment/picoclaw.service $remoteUser@$remoteHost:$remoteDir/

Write-Host "Building on remote server..."
ssh $remoteUser@$remoteHost "cd $remoteDir && go build -o picoclaw ./cmd/picoclaw/main.go"

Write-Host "Setting up systemd service..."
ssh $remoteUser@$remoteHost "sudo cp $remoteDir/picoclaw.service /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable picoclaw && sudo systemctl restart picoclaw"

Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green
