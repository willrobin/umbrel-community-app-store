# Music Assistant for umbrelOS

Music Assistant is a free, open-source media library manager that unifies all your music sources and connects them to a wide range of speakers and players.

**Upstream Project:** [https://github.com/music-assistant/server](https://github.com/music-assistant/server)

**Documentation:** [https://music-assistant.io](https://music-assistant.io)

---

## Features

- **Unified Music Library**: Connect Spotify, YouTube Music, Tidal, Qobuz, local files, and more
- **Wide Player Support**: Chromecast, Sonos, AirPlay, Squeezebox, DLNA, Home Assistant media players
- **Multi-Room Audio**: Synchronized playback across multiple rooms
- **Smart Playlists**: Automatic playlist generation based on your preferences
- **High-Quality Audio**: Support for lossless and high-resolution audio formats
- **Home Assistant Integration**: Seamless control via Home Assistant

---

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 3005 | TCP | Umbrel UI proxy (internal) |
| 18095 | TCP | Web UI and REST API (Home Assistant integration) |
| 8097 | TCP | Audio streaming to players |
| 3483 | TCP/UDP | Slimproto (Squeezebox players) |

---

## Home Assistant Integration

Music Assistant is designed to work seamlessly with Home Assistant on Umbrel.

### Automatic Discovery

Home Assistant should automatically discover Music Assistant on your network. If it does, you'll see a notification in Home Assistant to set up the integration.

### Manual Setup

If automatic discovery doesn't work:

1. In Home Assistant, go to **Settings** > **Devices & Services**
2. Click **Add Integration**
3. Search for **Music Assistant**
4. Enter the server address: `http://umbrel.local:18095`

### Requirements

- Music Assistant integration requires server version 2.4 or later (this package includes 2.7.4)
- Both apps must be on the same network

---

## Volumes

| Container Path | Host Path | Purpose |
|----------------|-----------|---------|
| `/data` | `${APP_DATA_DIR}/data` | Persistent configuration and database |
| `/media/music` | Umbrel storage: `music/` | Local music files |
| `/media/downloads` | Umbrel storage: `downloads/` | Downloaded media |

### Adding Local Music

1. Place your music files in Umbrel's shared storage under the `music` folder
2. In Music Assistant, go to **Settings** > **Music Providers**
3. Add **Filesystem** provider and configure `/media/music` as the source

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LOG_LEVEL` | `info` | Logging verbosity: `debug`, `info`, `warning`, `error` |

---

## Connecting Streaming Services (Spotify, YouTube Music, etc.)

Many streaming services like Spotify require OAuth authentication with a callback URL. By default, Music Assistant may detect an internal Docker IP address that isn't reachable from your browser.

### Configure the Base URL

**Before connecting streaming services**, configure the correct base URL:

1. Open Music Assistant at `http://umbrel.local:18095` (or use your Umbrel's IP address)
2. Go to **Settings** > **Core** > **Webserver**
3. Set **Base URL** to: `http://umbrel.local:18095` (or `http://<your-umbrel-ip>:18095`)
4. Click **Save**

> **Note:** There's a known bug in version 2.7.x where the Base URL may not persist after restart. If you experience this issue, check the [Music Assistant GitHub](https://github.com/music-assistant/support/issues) for updates.

### Alternative: Use the Host IP

If `umbrel.local` doesn't work, find your Umbrel's IP address:
- Check your router's connected devices list
- Or run `hostname -I` on your Umbrel via SSH

Then use `http://<IP-ADDRESS>:18095` as the Base URL.

### Connecting Spotify

1. Configure the Base URL (see above)
2. Go to **Settings** > **Music Providers** > **Add Provider**
3. Select **Spotify**
4. Click **Authenticate** - you'll be redirected to Spotify's login
5. After logging in, Spotify will redirect back to Music Assistant

If the callback fails, verify your Base URL is correctly set and accessible from your browser.

---

## Supported Music Providers

- Spotify
- YouTube Music
- Tidal
- Qobuz
- Deezer
- Apple Music (via AirPlay)
- Plex
- Jellyfin
- Subsonic
- Local filesystem
- Radio stations (TuneIn, Radio Browser)
- Podcasts

---

## Supported Players

- **Chromecast**: Google Chromecast devices and Google Home speakers
- **Sonos**: Sonos speakers (via native integration)
- **AirPlay**: Apple HomePod, AirPlay-enabled speakers
- **Squeezebox**: Logitech Media Server compatible players
- **DLNA**: DLNA/UPnP compatible speakers
- **Home Assistant**: Any media player entity in Home Assistant
- **Snapcast**: Multi-room audio via Snapcast
- **Built-in Players**: Browser-based playback

---

## Troubleshooting

### Players Not Found

1. Ensure your players are on the same network as Umbrel
2. Check that firewall isn't blocking ports 18095, 8097
3. For Chromecast/AirPlay: mDNS discovery may need additional network configuration

### Home Assistant Can't Connect

1. Verify Music Assistant is running: access `http://umbrel.local:18095`
2. Check both apps are on the same Docker network
3. Try using the IP address instead of hostname

### Audio Playback Issues

1. Ensure port 8097 is accessible from your players
2. Check the player is compatible and properly configured
3. Review logs in Music Assistant: **Settings** > **Core** > **Logging**

### OAuth/Callback Errors (Spotify, YouTube Music, etc.)

If you see callback errors like "address could not be resolved" or the callback redirects to an internal IP (e.g., `10.21.0.x`):

1. **Configure Base URL**: Go to **Settings** > **Core** > **Webserver** and set Base URL to `http://umbrel.local:18095`
2. **Use IP instead**: If `umbrel.local` doesn't work, use your Umbrel's actual IP address
3. **Check browser access**: Verify you can open `http://umbrel.local:18095` in your browser
4. **Known bug**: Version 2.7.x has a bug where Base URL may not save. Check for updates at the [Music Assistant GitHub](https://github.com/music-assistant/support/issues/4547)

---

## Hardware Requirements

- **CPU**: 64-bit Intel (max 10 years old), AMD (max 5 years old), or Raspberry Pi 4+
- **RAM**: Minimum 2GB (4GB+ recommended)
- **Storage**: Depends on library size and cache settings

---

## Links

- [Music Assistant Website](https://music-assistant.io)
- [GitHub Repository](https://github.com/music-assistant/server)
- [Documentation](https://music-assistant.io/installation/)
- [Community Discussions](https://github.com/orgs/music-assistant/discussions)
- [Home Assistant Integration](https://www.home-assistant.io/integrations/music_assistant)
