# AzuraCast

AzuraCast is a self-hosted, all-in-one web radio management suite. Run multiple radio stations, manage media libraries, create playlists, and stream to listeners worldwide from a single dashboard.

## Features

- Unlimited radio stations per installation
- Web-based station management dashboard
- Built-in AutoDJ with smart playlists
- Live DJ support with Icecast and SHOUTcast
- Listener statistics and analytics
- Podcast and on-demand content support
- Mobile-friendly web player
- RESTful API for integrations

## Links

- **Website:** https://www.azuracast.com
- **Documentation:** https://docs.azuracast.com
- **Repository:** https://github.com/AzuraCast/AzuraCast
- **Support:** https://github.com/AzuraCast/AzuraCast/discussions

## Access

| Service | URL |
|:--------|:----|
| Web UI | `http://umbrel.local:3004` |
| Stream Ports | `20000-20050` |

## Configuration

After installation, create your first admin account through the web interface. AzuraCast will guide you through initial setup.

### Streaming Ports

AzuraCast automatically assigns ports from the 20000-20050 range for your radio stations. These ports are exposed for external streaming clients and players.

### Data Storage

| Volume | Path |
|:-------|:-----|
| App data | `${APP_DATA_DIR}/data/azuracast` |
| Database | `${APP_DATA_DIR}/data/db` |
| Redis cache | `${APP_DATA_DIR}/data/redis` |

## Notes

- Database credentials are automatically generated using Umbrel's secure seed mechanism
- Streaming ports (20000-20050) are exposed directly for listener access
- No external dependencies required - AzuraCast is fully self-contained

## Developer

**AzuraCast** - https://www.azuracast.com

---

*Submitted by [Kasa](https://github.com/willrobin/umbrel-community-app-store)*
