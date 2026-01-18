# AzuraCast

AzuraCast is a self-hosted, all-in-one web radio management suite. Run multiple
stations, manage media libraries, schedule playlists, and stream to listeners
worldwide from a single intuitive dashboard.

## Features

- **Multiple Stations** - Run several radio stations from one installation
- **Media Management** - Upload, organize, and schedule your audio content
- **Live DJ Streaming** - Allow DJs to broadcast live via source clients
- **Listener Statistics** - Track real-time and historical listener data
- **Podcast Support** - Host and distribute podcasts alongside your stations
- **Icecast & Shoutcast** - Compatible with major streaming protocols

## Links

- Website: https://www.azuracast.com
- Documentation: https://www.azuracast.com/docs/
- Repository: https://github.com/AzuraCast/AzuraCast
- Issues: https://github.com/AzuraCast/AzuraCast/issues

## Configuration

| Setting | Value |
|---------|-------|
| Web UI | `http://umbrel.local:3004` |
| Default Port | 3004 |
| Streaming Ports | 20000-20050 |

### Data Volumes

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `${APP_DATA_DIR}/azuracast` | `/var/azuracast` | Main application data |
| `${APP_DATA_DIR}/azuracast/db` | `/var/lib/mysql` | MariaDB database |
| `${APP_DATA_DIR}/azuracast/redis` | `/data` | Redis cache |

## Getting Started

1. Install the app from the Kasa community store
2. Access the web interface at `http://umbrel.local:3004`
3. Complete the initial setup wizard
4. Create your first radio station

## Notes

- AzuraCast manages station streaming internally using Icecast
- External streaming ports 20000-20050 are exposed for direct player connections
- The database uses secure credentials generated from your Umbrel's app seed
- For advanced configuration, refer to the upstream documentation
