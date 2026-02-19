# deploy_to_poweredge.ps1

$remoteHost = "100.76.177.12"
$remoteUser = "racer"
$remoteDir = "~/picoclaw"

Write-Host "Creating remote directory..."
ssh $remoteUser@$remoteHost "mkdir -p $remoteDir"

Write-Host "Transferring files..."
# Transfer source code (Go files, go.mod, go.sum)
scp -r cmd pkg go.mod go.sum $remoteUser@$remoteHost:$remoteDir/

# Transfer deployment config
scp deployment/config.json $remoteUser@$remoteHost:$remoteDir/config.json
scp deployment/.env $remoteUser@$remoteHost:$remoteDir/.env
scp deployment/picoclaw.service $remoteUser@$remoteHost:$remoteDir/

Write-Host "Building on remote server..."
ssh $remoteUser@$remoteHost "cd $remoteDir && go build -o picoclaw ./cmd/picoclaw/main.go"

Write-Host "Setting up systemd service..."
ssh $remoteUser@$remoteHost "sudo cp $remoteDir/picoclaw.service /etc/systemd/system/ && sudo systemctl daemon-reload && sudo systemctl enable picoclaw && sudo systemctl restart picoclaw"

Write-Host "Deployment complete!"
