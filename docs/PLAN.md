# Plan - Update Model to Kimi-K2.5 via Ollama

## Phase 1: Planning
- [x] Analyze user request: Change model to `kimi-k2.5:cloud` via Ollama provider.
- [ ] Create/Update configuration file.

## Phase 2: Implementation (After Approval)
- [ ] **DevOps**: Update `deployment/config.json` with `model: kimi-k2.5:cloud`.
- [ ] **DevOps**: Transfer `config.json` to `100.76.177.12`.
- [ ] **DevOps**: Move `config.json` to `~/.picoclaw/config.json`.
- [ ] **DevOps**: Restart `picoclaw.service`.
- [ ] **Test**: Check `journalctl -u picoclaw` to verify the model change in the logs.

## Verification
- [ ] Confirm bot responds using the new model.
