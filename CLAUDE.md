# lofi-stream-docs

Central documentation hub and DevOps scripts for the lofi-stream project.

## Project Structure

```
~/
├── lofi-stream-youtube/     # Night city theme → YouTube (:99)
├── lofi-stream-twitch/      # Coffee shop theme → Twitch (:98)
├── lofi-stream-kick/        # Arcade theme → Kick (:97)
├── lofi-stream-rumble/      # Library theme → Rumble (:96)
└── lofi-stream-docs/        # This repo (documentation + DevOps)
```

## Secrets

All secrets stored in `~/api-secrets/lofi-stream/` (private repo):

```
lofi-stream/
├── hetzner/
│   ├── prod.env    # Production IP, user, SSH key path
│   └── dev.env     # Dev IP, users, SSH key path
└── platforms/
    ├── youtube.env # Stream key + RTMP URL
    ├── twitch.env  # Stream key + RTMP URL
    ├── kick.env    # Stream key + RTMP URL
    └── rumble.env  # Stream key + RTMP URL (pending)
```

SSH key: `~/api-secrets/hetzner-server/id_ed25519`

## Infrastructure

| Server | IP | Purpose | Cost |
|--------|-----|---------|------|
| Production (CPX62) | 135.181.150.82 | Live streams | $42.99/mo |
| Dev (CX22) | 5.78.42.22 | Testing | €4.50/mo |

## Repository Contents

```
lofi-stream-docs/
├── CLAUDE.md              # This file
├── README.md              # Public readme
├── index.html             # Main docs page (GitHub Pages)
├── architecture.html      # System architecture diagrams
├── platforms.html         # Platform comparison (24+ destinations)
├── devops.html            # DevOps documentation
└── scripts/               # Server management scripts
    ├── setup-dev-user.sh  # Creates lofidev user on dev server
    ├── reset-dev.sh       # Daily reset script (installed to /opt/scripts/)
    ├── install-dev-reset.sh # Installs cron job for daily reset
    └── check-streams.sh   # Health check for production streams
```

## Dev Server Usage

The dev server (5.78.42.22) uses a dedicated `lofidev` user for testing.

### Deploy/Test from Stream Repos

From any stream repo (`lofi-stream-youtube`, `lofi-stream-twitch`, `lofi-stream-kick`, `lofi-stream-rumble`):
```bash
make deploy-dev    # Deploy repo to dev server
make cleanup-dev   # Remove repo from dev server
make dev-status    # Show what's deployed
make dev-reset     # Full reset (as root)
```

### SSH Access
```bash
# As lofidev (for testing)
ssh -i ~/api-secrets/hetzner-server/id_ed25519 lofidev@5.78.42.22

# As root (for admin)
ssh -i ~/api-secrets/hetzner-server/id_ed25519 root@5.78.42.22
```

### Dev Server Auto-Reset

The dev server resets daily at 4 AM UTC:
- Kills all lofidev processes (except SSH)
- Cleans home directory (preserves .ssh, .bashrc)
- Recreates empty `streams/` directory

Manual reset:
```bash
ssh root@5.78.42.22 '/opt/scripts/reset-dev.sh'
```

View logs:
```bash
ssh root@5.78.42.22 'cat /var/log/dev-reset.log'
```

## Setting Up a New Dev Server

If you need to recreate the dev server:

```bash
# 1. Copy scripts to server
scp scripts/*.sh root@5.78.42.22:/tmp/

# 2. SSH in and run setup
ssh root@5.78.42.22

# Create lofidev user
bash /tmp/setup-dev-user.sh

# Install reset script and cron
bash /tmp/install-dev-reset.sh

# 3. Add your SSH key to lofidev
cat ~/.ssh/id_ed25519.pub >> /home/lofidev/.ssh/authorized_keys
```

## Quick Commands

```bash
# View docs locally
cd ~/lofi-stream-docs && python3 -m http.server 8080

# Check production streams
ssh root@135.181.150.82 'systemctl status lofi-stream lofi-stream-twitch'

# Run health check on production
ssh root@135.181.150.82 '/opt/scripts/check-streams.sh'

# Check dev server status
ssh lofidev@5.78.42.22 'ls -la ~/streams/'
```

## Live Sites

- **Docs:** https://ldraney.github.io/lofi-stream-docs/
- **YouTube Page:** https://ldraney.github.io/lofi-stream-youtube/
- **Twitch Page:** https://ldraney.github.io/lofi-stream-twitch/
- **Kick Page:** https://ldraney.github.io/lofi-stream-kick/
- **Rumble Page:** https://ldraney.github.io/lofi-stream-rumble/

## Stream Configuration

| Platform | Display | Audio Sink | Bitrate | Status |
|----------|---------|------------|---------|--------|
| YouTube | :99 | virtual_speaker | 1.5 Mbps | LIVE |
| Twitch | :98 | twitch_speaker | 2.5 Mbps | LIVE |
| Kick | :97 | kick_speaker | 6.0 Mbps | LIVE |
| Rumble | :96 | rumble_speaker | 4.5 Mbps | Ready |
