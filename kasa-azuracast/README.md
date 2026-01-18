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
| Streaming Ports | 8000-8010 |

### Data Volumes

This app uses Docker named volumes to ensure proper initialization of AzuraCast's
internal directory structure. Data is stored in the following volumes:

| Volume | Purpose |
|--------|---------|
| `station_data` | Radio station configurations |
| `backups` | Automatic backups |
| `db_data` | MariaDB database |
| `www_uploads` | User uploads |
| `tmp_data` | Temporary files |

## Getting Started

1. Install the app from the Kasa community store
2. Access the web interface at `http://umbrel.local:3004`
3. Complete the initial setup wizard to create your admin account
4. Create your first radio station

## Streaming Ports

Listeners can connect directly to your radio streams using ports 8000-8010.
Each station you create will be assigned a port from this range. Example stream URLs:

- `http://your-umbrel-ip:8000/radio.mp3`
- `http://your-umbrel-ip:8001/listen`

## Notes

- AzuraCast is an all-in-one image that includes MariaDB, Redis, and Icecast
- The web interface is proxied through Umbrel's app proxy on port 3004
- For advanced configuration, refer to the upstream documentation
