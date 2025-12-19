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
├── lofi-stream-frontend/    # Status page (served from VPS)
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
    ├── dlive.env   # Stream key + RTMP URL
    └── odysee.env  # Stream key + RTMP URL
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

- **Status Dashboard:** http://lofi-status.duckdns.org/ (live stream status, updates every 60s)
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
| DLive | :95 | dlive_speaker | 4.5 Mbps | LIVE |
| Odysee | :94 | odysee_speaker | 3.5 Mbps | LIVE |

---

## Roadmap: Content Partnerships

**The Vision:** Become a distribution partner for Alan Watts' teachings - not just using content, but actively promoting authentic materials to a new generation through lofi streams. We spread the ideas, drive people to official sources, and share in the success.

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Polish 5       │     │  Partner with   │     │  Spread ideas + │
│  Streams        │ ──► │  Alan Watts Org │ ──► │  Drive to source│
│  (Portfolio)    │     │  (Mission-aligned)    │  (Aligned revenue)
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

### Why This Direction

- **Mission-aligned:** We're not extracting value, we're amplifying reach to new audiences
- **Promotes authentic sources:** Every stream links to official books, lectures, and materials
- **Lofi reaches new demographics:** Young people studying/working discover Watts through our aesthetic
- **Legal and legitimate:** Partnership protects both parties from copyright issues
- **Revenue follows value:** We only make money when we successfully spread the teachings

### The Format: Alan Watts Radio

The partnership allows up to 15 minutes of content per segment. We turn this into a radio station format:

```
┌────────────────────┐   ┌────────────────────┐   ┌────────────────────┐
│  15 min lecture    │   │  Lofi break        │   │  15 min lecture    │
│  "The Art of       │ → │  ♪ chill music ♪   │ → │  "The Nature of    │
│   Meditation"      │   │  "Up next: ..."    │   │   Consciousness"   │
│                    │   │  Source: [link]    │   │                    │
└────────────────────┘   └────────────────────┘   └────────────────────┘
```

**During each lecture:**
- On-screen overlay: lecture title, source album/collection
- Chat bot posts affiliate link to full lecture
- Visual theme matches the topic

**During lofi breaks:**
- "Coming up next: [Lecture Title]"
- "Previous lecture from: [Album Name] - available at alanwatts.org"
- Affiliate links in description and chat
- Pure lofi vibes for studying/working

**The pitch:** We're not just using clips - we're building a curated radio experience that drives people to buy the full lectures.

### Theme → Philosophy Pairing

| Theme | Stream Vibe | Potential Watts Topics |
|-------|-------------|------------------------|
| Night City | Cyberpunk/neon | Technology & humanity, modern alienation, finding meaning |
| Coffee Shop | Cozy/warm | Presence, mindfulness, the art of living |
| Arcade | Retro gaming | Play, spontaneity, not taking life too seriously |
| Library | Quiet/studious | Eastern philosophy, meditation, wisdom traditions |
| Space Station | Cosmic/vast | The universe, consciousness, interconnection |
| Underwater | Flowing/calm | Going with the flow, water philosophy, naturalness |

### Phase 1: Add Radio Features to Live Streams

**Status:** Streams are already running with Alan Watts content. Now add the "radio station" polish that makes it partnership-ready.

- [ ] **Add overlay system** - "Now playing:", "Up next:", source album attribution
- [ ] **Set up chat bot** - Auto-posts affiliate links during/after each segment
- [ ] **Update stream descriptions** - Links to alanwatts.org, books, lecture collections
- [ ] **Create lecture rotation playlists** - Curate 15-min segments matched to each theme
- [ ] **Add lofi break screens** - "Coming up next...", "Previous lecture from..."
- [ ] **Record demo video** - Capture the full experience for the application

### Phase 2: Submit Polished Application

- [ ] **Compile demo materials** - Links to working streams + demo video of radio format
- [ ] **Submit to Alan Watts org** - https://alanwatts.org (YouTube Partnerships program)
- [ ] **Show them it's ready** - "Approve us and we flip the switch"
- [ ] **Emphasize affiliate angle** - We actively drive purchases, not just use content

### Phase 3: Go Live (Upon Approval)

- [ ] **Curate lecture library** - Select 15-min segments, match to themes
- [ ] **Create rotation schedules** - Different playlists for each themed stream
- [ ] **Swap in real content** - Replace placeholders with licensed Watts lectures
- [ ] **Monitor and optimize** - Which talks get best engagement?

### Phase 4: Growth (If Partnership Works)

- [ ] **Clips/Shorts** - Extract powerful moments for YouTube Shorts, TikTok, Reels
- [ ] **Cross-promote** - Each stream mentions the others
- [ ] **Community Discord** - For people who want to discuss the ideas
- [ ] **More partnerships** - Approach other estates (Terence McKenna, Joseph Campbell, Ram Dass)

### Phase 5: Platform Expansion (When Revenue Justifies)

Current: 5 platforms on $50/mo server. Expand only when partnership revenue covers costs.

**Potential platforms to add:**
- [ ] Facebook Live
- [ ] X (Twitter) Live
- [ ] LinkedIn Live
- [ ] Trovo
- [ ] TikTok Live
- [ ] Instagram Live (requires mobile workaround)

**Note:** Radio format is low-maintenance once running. Design updates are creative choice, not required work. Scale when it makes financial sense, not before.

### Revenue Model (All Aligned with Mission)

| Source | How It Works | Notes |
|--------|--------------|-------|
| Content rev share | 50/50 on Watts content in streams | Primary partnership value |
| YouTube AdSense | Platform pays for views | Requires 1000 subs + 4000 watch hours |
| Book affiliates | Link to official books (Amazon, alanwatts.org) | Every stream description |
| Lecture sales | Drive traffic to official lecture recordings | alanwatts.org store |
| Official merch | If they have an affiliate program | TBD |
| Super chats | Engaged viewers donate | Variable |

**Key point:** Every revenue stream drives people toward authentic Alan Watts materials. We succeed when viewers discover the source.

### What We Offer the Partnership

- **5 themed 24/7 streams** across YouTube, Twitch, Kick, DLive, Odysee
- **Consistent linking** to alanwatts.org in all descriptions, overlays, chat bots
- **Curated pairings** - matching specific talks to visual themes for deeper impact
- **New audience reach** - lofi study/work viewers who might not seek out philosophy directly
- **Professional production** - automated, reliable, high-quality streams

### Current Infrastructure Cost

| Item | Cost |
|------|------|
| Production VPS (CPX62) | $42.99/mo |
| Dev VPS (CX22) | ~$5/mo |
| Domain/DNS | Free (duckdns) |
| **Total** | ~$48/mo |

No additional costs until we have revenue to justify them.

---

## Alan Watts Partnership Application

**Application URL:** https://alanwatts.org (YouTube Partnerships section)

### Draft Message for Application

> I've already built something I hope you'll appreciate - a network of 24/7 "Alan Watts Radio" lofi streams that are live right now as a passion project.
>
> I own the complete lecture library and have been pairing talks with themed visual environments: cyberpunk cityscapes, cozy coffee shops, retro arcades, quiet libraries. Each stream runs 15-minute lecture segments with lofi music breaks in between - designed around your partnership guidelines.
>
> **What's already running:**
> - 5 themed 24/7 streams across YouTube, Twitch, Kick, DLive, and Odysee
> - [LINKS TO LIVE STREAMS]
> - Professional automated infrastructure with reliable uptime
> - Lecture segments matched to visual themes (presence/mindfulness for cozy vibes, play/spontaneity for arcade, etc.)
>
> **What I'd like to formalize:**
> - Official partnership so I can properly attribute and link to alanwatts.org
> - Affiliate links in all stream descriptions, overlays, and chat bots
> - Revenue share on the content I'm already sharing with viewers
> - On-screen overlays showing lecture titles, source albums, and where to buy the full collection
>
> **Why this works:**
> - Viewers get a 15-minute taste → see where to buy the full lecture → discover more
> - Each segment is essentially an advertisement for the complete collection
> - The lofi study/work demographic discovers Watts through an aesthetic they already love
> - We succeed when viewers want MORE and go to alanwatts.org to get it
>
> I built this because Alan Watts' teachings have meant a lot to me, and I wanted to share them with a new generation in a format that fits how they consume content. I'd love to do this properly as partners - turning on monetization and affiliate links together, with full attribution driving people to authentic sources.
>
> I'd love to discuss how we can work together.

### Form Field Suggestions

| Field | Value |
|-------|-------|
| Your role | Content Creator (or select appropriate) |
| Type of project | YOUTUBE |
| Time frame | Ongoing 24/7 streams - ready to begin integration immediately upon approval |
| Website | https://ldraney.github.io/lofi-stream-docs/ |
| Link to project preview | Links to live streams (YouTube, Twitch, etc.) |
| Country of Residency | USA |
