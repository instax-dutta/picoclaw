# Plan - PicoClaw Deployment to PowerEdge

## Phase 1: Configuration & Preparation
- [ ] Create `deployment/config.json` with Ollama and Telegram settings.
- [ ] Create `deployment/.env` with the Telegram bot token.
- [ ] Prepare a deployment script `deploy.ps1` to handle the transfer.

## Phase 2: Remote Setup (via SSH)
- [ ] Create `~/picoclaw` directory on remote.
- [ ] Transfer source code or binary (Build on remote is safer if local Go is missing).
- [ ] Install dependencies on remote (if any).

## Phase 3: Service Management
- [ ] Create `picoclaw.service` systemd unit file.
- [ ] Enable and start the service.
- [ ] Verify logs.

## Constraints
- Host: `100.76.177.12`
- User: `racer`
- Password: `racerop` (Will attempt to use via script or ask user for key setup)
- Model: `granite4:latest` (Ollama)
- Telegram: Token provided, User ID: `1826635534`
