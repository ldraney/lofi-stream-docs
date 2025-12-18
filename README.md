# lofi-stream-docs

Central documentation hub for the lofi-stream project - 24/7 multi-platform lofi streaming infrastructure.

## View the Docs

**Live site:** https://ldraney.github.io/lofi-stream-docs/

```bash
# Or view locally
cd ~/lofi-stream-docs
python3 -m http.server 8080
# Open http://localhost:8080
```

## Project Structure

```
~/
├── lofi-stream-youtube/     # Night city theme → YouTube
├── lofi-stream-twitch/      # Coffee shop theme → Twitch
└── lofi-stream-docs/        # This repo (documentation hub)
```

## Related Repositories

| Repo | Theme | Platform | Status |
|------|-------|----------|--------|
| [lofi-stream-youtube](https://github.com/ldraney/lofi-stream-youtube) | 🌃 Night City | YouTube | LIVE |
| [lofi-stream-twitch](https://github.com/ldraney/lofi-stream-twitch) | ☕ Coffee Shop | Twitch | LIVE |
| [lofi-stream-docs](https://github.com/ldraney/lofi-stream-docs) | 📚 Docs Hub | GitHub Pages | This repo |

## What's in the Docs

- **index.html** - Project overview, unified roadmap, stream comparison
- **platforms.html** - Platform comparison (24+ RTMP destinations)
- **architecture.html** - System architecture diagrams
- **devops.html** - Server setup, deployment, and operations

## Infrastructure

### Production Server (CPX62 - $42.99/mo)
- **IP:** 135.181.150.82
- **Specs:** 16 vCPU AMD, 32GB RAM, 640GB NVMe
- **Capacity:** 16-20 simultaneous streams
- **Current usage:** 2 streams (~17% CPU, ~1.4GB RAM)
- Separate virtual displays (`:99` for YouTube, `:98` for Twitch)
- Separate PulseAudio sinks (`virtual_speaker`, `twitch_speaker`)
- systemd services with auto-restart

### Dev Server (CX22 - €4.50/mo)
- **IP:** 5.78.42.22
- **Specs:** 2 vCPU, 2GB RAM
- **Purpose:** Testing new themes and features before deploying to prod

## Roadmap Summary

| Phase | Name | Status |
|-------|------|--------|
| 1 | Foundation - YouTube | Done |
| 2 | Expansion - Twitch | Done |
| 3 | Scale Up Infrastructure | Done |
| 4 | Documentation & DevOps | Done |
| 5 | Multi-Platform Expansion | Next |
| 6 | Visual & Audio Polish | Planned |
| 7 | Monetization | Planned |
| 8 | Interactive Features | Vision |
