# lofi-stream-docs

Central documentation hub and DevOps scripts for the lofi-stream project.

## Project Structure

```
~/
├── lofi-stream-youtube/     # Night city theme → YouTube (:99)
├── lofi-stream-twitch/      # Coffee shop theme → Twitch (:98)
├── lofi-stream-kick/        # Arcade theme → Kick (:97)
├── lofi-stream-rumble/      # Library theme → Rumble (:96)
├── lofi-stream-dlive/       # Space station theme → DLive (:95)
├── lofi-stream-odysee/      # Underwater theme → Odysee (:94)
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
    ├── rumble.env  # Stream key + RTMP URL (needs followers)
    ├── dlive.env   # Stream key + RTMP URL (pending)
    └── odysee.env  # Stream key + RTMP URL (pending)
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
- **DLive Page:** https://ldraney.github.io/lofi-stream-dlive/
- **Odysee Page:** https://ldraney.github.io/lofi-stream-odysee/

## Stream Configuration

| Platform | Display | Audio Sink | Bitrate | Status |
|----------|---------|------------|---------|--------|
| YouTube | :99 | virtual_speaker | 1.5 Mbps | LIVE |
| Twitch | :98 | twitch_speaker | 2.5 Mbps | LIVE |
| Kick | :97 | kick_speaker | 6.0 Mbps | LIVE |
| Rumble | :96 | rumble_speaker | 4.5 Mbps | Needs followers |
| DLive | :95 | dlive_speaker | 4.5 Mbps | Ready |
| Odysee | :94 | odysee_speaker | 3.5 Mbps | Ready |

---

## Roadmap: Streams → Vibe Sites → Stores

**The Vision:** 15+ automated streams → interactive websites (games/experiences) → curated dropship stores. Each funnel matches a vibe. Feels like discovering a cool local shop, not a sales pitch.

```
┌─────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  24/7       │     │  Interactive    │     │  Dropship       │
│  Streams    │ ──► │  Vibe Sites     │ ──► │  Stores         │
│  (15+)      │     │  (Games/Art)    │     │  (Curated)      │
└─────────────┘     └─────────────────┘     └─────────────────┘
```

### Theme → Vibe → Products

| Theme | Stream Vibe | Site Experience | Store Products |
|-------|-------------|-----------------|----------------|
| Night City | Cyberpunk/neon | Explore rooftops, click neon signs | Tech gear, LED strips, mechanical keyboards |
| Coffee Shop | Cozy/warm | Arrange items, discover recipes | Coffee beans, mugs, cozy apparel |
| Arcade | Retro gaming | Mini-games, easter eggs | Retro consoles, posters, pixel art |
| Library | Quiet/studious | Browse shelves, find hidden notes | Books, stationery, reading lamps |

### Phase 1: Foundation (Current Month)

- [ ] **Expand to 15 platforms** - Add Facebook, X, LinkedIn Live, DLive, Trovo, etc.
- [ ] **Unified branding** - Consistent channel art, descriptions, links across all platforms
- [ ] **Bio links everywhere** - Every platform links to its vibe site
- [ ] **Set up affiliate accounts** - Amazon Associates, coffee brands, tech gear programs
- [ ] **Automate clip extraction** - FFmpeg script to pull highlights for Shorts/TikTok/Reels

### Phase 2: Interactive Vibe Sites

- [ ] **Upgrade GitHub Pages sites** - Transform from static pages to interactive experiences
- [ ] **Add clickable elements** - Objects in the scene link to products or surprises
- [ ] **Easter eggs & discoveries** - Hidden interactions reward exploration
- [ ] **Mobile-friendly** - Touch interactions work on phones
- [ ] **Each site unique** - Night city feels different from coffee shop feels different from arcade

### Phase 3: Dropship Stores

- [ ] **Shopify stores per vibe** - Or one store with vibe-based collections
- [ ] **Curated products only** - Nothing that breaks the aesthetic
- [ ] **Dropshipping setup** - Zero inventory (Printful, Spocket, DSers)
- [ ] **Seamless transitions** - Site experience flows naturally into store
- [ ] **Fun product descriptions** - Match the vibe, not generic copy

### Phase 4: Content Flywheel

- [ ] **Daily short-form clips** - Automated or semi-automated posting
- [ ] **Cross-promotion** - Each stream mentions other vibes
- [ ] **Community Discord** - Central hub for all vibes
- [ ] **Email capture** - "Get notified of new discoveries" on each site

### Phase 5: Scale & Optimize

- [ ] **A/B test site interactions** - What gets clicks?
- [ ] **Track funnel metrics** - Stream → Site → Store conversion
- [ ] **Add more vibes/themes** - Space station, rainy Tokyo, forest cabin
- [ ] **Sponsorships** - Brands pay to be featured in the vibe

### Revenue Targets

| Phase | Monthly Revenue | Notes |
|-------|-----------------|-------|
| Phase 1 | $0-50 | Building foundation, affiliate links live |
| Phase 2 | $50-200 | Sites drive engagement, some affiliate sales |
| Phase 3 | $200-500 | Stores live, dropship margins ~20-30% |
| Phase 4 | $500-1500 | Flywheel working, multiple revenue streams |
| Phase 5 | $1500+ | Optimized funnels, potential sponsorships |

### Tech Stack (Planned)

| Layer | Tool | Cost |
|-------|------|------|
| Streaming | Hetzner VPS + FFmpeg | ~$50/mo |
| Vibe Sites | GitHub Pages (free) or Vercel | $0-20/mo |
| Stores | Shopify Basic | $29/mo per store |
| Dropship | Printful/Spocket | $0 (margin on sales) |
| Short-form | CapCut (free) + scheduling tool | $0-15/mo |
| Links | Linktree or custom | $0 |

**Total overhead:** ~$80-150/mo for the entire ecosystem
