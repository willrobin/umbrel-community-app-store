# Music Assistant for umbrelOS

Music Assistant is a free, open-source media library manager that connects to your streaming services and a wide range of connected speakers.

## Links

- **Website:** https://music-assistant.io
- **Documentation:** https://music-assistant.io/installation/
- **Source Code:** https://github.com/music-assistant/server
- **Support:** https://github.com/orgs/music-assistant/discussions

## Features

- Connect multiple music providers (Spotify, YouTube Music, Tidal, Qobuz, Subsonic, local files)
- Stream to various players (Home Assistant, Sonos, Chromecast, Airplay, Snapcast, DLNA)
- Unified library view across all connected sources
- Queue management with crossfade and gapless playback
- Multi-room audio synchronization
- Built-in equalizer and DSP features

## Access

- **Web Interface:** http://umbrel.local:8095
- **Streaming Port:** 8097 (for audio streaming to players)

## First-Time Setup

1. Open the Music Assistant web interface
2. Add your music providers (Spotify, YouTube Music, local files, etc.)
3. Configure your audio players (Chromecast, Sonos, Airplay, etc.)
4. Start enjoying your unified music library!

## Configuration

### Adding Local Music

To add local music files, you need to mount your music directory. Edit the `docker-compose.yml` and uncomment/modify the volume mount:

```yaml
volumes:
  - ${APP_DATA_DIR}/data:/data
  - /path/to/your/music:/media:ro
```

### Supported Music Providers

- Spotify (Premium required)
- YouTube Music
- Tidal
- Qobuz
- Deezer
- Subsonic/Airsonic
- Plex
- Jellyfin
- Local filesystem

### Supported Players

- Home Assistant media players
- Chromecast / Google Cast
- Sonos
- Airplay
- Snapcast
- DLNA/UPnP
- Slimproto (Squeezebox)
- Browser-based playback

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| LOG_LEVEL | info | Logging verbosity (debug, info, warning, error) |

## Data Storage

All Music Assistant data is stored in:
- `${APP_DATA_DIR}/data` - Configuration, database, and cache

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 8095 | TCP | Web interface |
| 8097 | TCP | Audio streaming to players |

## Security Notice

Music Assistant does not have built-in authentication. It is designed to run on a private home network. Do not expose this application directly to the internet without additional security measures (VPN, reverse proxy with authentication, etc.).

## Troubleshooting

### Players not discovering Music Assistant

Some player types require network discovery (mDNS/SSDP). If players cannot discover Music Assistant automatically:
1. Manually add the player using its IP address
2. Ensure your network allows multicast traffic
3. Check that ports 8095 and 8097 are accessible

### Audio streaming issues

Ensure port 8097 is accessible from your player devices. This is the port Music Assistant uses to stream audio.

## License

Music Assistant is licensed under the Apache-2.0 License.
