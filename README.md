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
- **architecture.html** - Detailed system diagrams (TODO)

## Infrastructure

Both streams run on a single Hetzner CX22 VPS (€4.50/mo):
- Separate virtual displays (`:99` for YouTube, `:98` for Twitch)
- Separate PulseAudio sinks (`virtual_speaker`, `twitch_speaker`)
- systemd services with auto-restart

## Roadmap Summary

| Phase | Name | Status |
|-------|------|--------|
| 1 | Foundation - YouTube | Done |
| 2 | Expansion - Twitch | Done |
| 3 | Documentation & Operations | In Progress |
| 4 | Visual & Audio Polish | Planned |
| 5 | Multi-Platform Expansion | Planned |
| 6 | Monetization | Planned |
| 7 | Interactive Features | Vision |
