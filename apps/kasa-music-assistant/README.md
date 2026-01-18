# Music Assistant

Music Assistant is a free, open-source music library manager that connects your
streaming services and local music files to a wide range of connected speakers.

## Features

- **Unified Music Library** - Connect Spotify, Tidal, YouTube Music, Qobuz, local files, and more
- **Multi-Room Audio** - Stream to Sonos, Chromecast, AirPlay, DLNA, Snapcast, and many others
- **Playlist Synchronization** - Create and manage playlists across all music sources
- **Home Assistant Integration** - Seamless integration for smart home automation

## Links

- Website: https://www.music-assistant.io
- Documentation: https://www.music-assistant.io/installation/
- Repository: https://github.com/music-assistant/server
- Issues: https://github.com/music-assistant/server/issues

## Configuration

| Setting | Value |
|---------|-------|
| Web UI | `http://umbrel.local:8096` |
| Default Port | 8096 |
| Stream Port | 8097 |

### Data Volumes

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `${APP_DATA_DIR}/data` | `/data` | Configuration and database |
| `${APP_DATA_DIR}/media` | `/media` | Local music files |

## Getting Started

1. Install the app from the Kasa community store
2. Access the web interface at `http://umbrel.local:8096`
3. Add your music providers (Spotify, Tidal, YouTube Music, etc.)
4. Configure your audio players (Sonos, Chromecast, AirPlay, etc.)
5. Enjoy your unified music library

## Adding Local Music

1. Place your music files in the app data directory under `media/`
2. Or connect streaming services directly in the web interface

## Notes

- Music Assistant uses **host network mode** for player discovery (Layer-2 network access required)
- There is **no login screen** - do not expose this app directly to the internet
- All devices (Umbrel and players) must be on the same network for discovery to work
- For advanced features, consider connecting to Home Assistant
