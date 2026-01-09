# Music Assistant

Music Assistant is a free, opensource Media library manager that connects to your streaming services and a wide range of connected speakers. Stream your music collection to Sonos, Google Cast, AirPlay, and many more players.

## Links
- Upstream: https://github.com/music-assistant/server
- Docs: https://music-assistant.io
- Issues: https://github.com/music-assistant/server/issues

## Configuration

### Ports
- **UI Port**: 3005 (Umbrel web interface)
- **Web Interface**: http://umbrel.local:3005
- **Streaming Port**: 8097 (exposed for Home Assistant and other clients)

### Data Volumes
- `${APP_DATA_DIR}/data` -> `/data` (Music Assistant configuration and database)
- `${APP_DATA_DIR}/media` -> `/media` (Optional: Local music library files)

### Supported Streaming Services
- Spotify
- YouTube Music
- Qobuz
- Tidal
- Deezer
- Apple Music (via Home Assistant)
- SoundCloud
- Tunein
- And many more...

### Supported Players
- Sonos
- Google Cast (Chromecast)
- AirPlay
- Snapcast
- SlimProto (Logitech Media Server)
- UPnP/DLNA
- And many more...

## Home Assistant Integration

Music Assistant is fully compatible with Home Assistant and can be automatically discovered.

### Setup with Home Assistant

1. **Install Music Assistant** on your Umbrel
2. **Install Home Assistant** (if not already installed)
3. **Automatic Discovery**: Home Assistant will automatically discover Music Assistant running on your network
4. **Manual Configuration** (if automatic discovery fails):
   - In Home Assistant, go to Settings → Devices & Services
   - Click "Add Integration"
   - Search for "Music Assistant"
   - Enter URL: `http://umbrel.local:3005` or `http://<umbrel-ip>:8095`

### Requirements for Home Assistant
- Music Assistant Server version 2.4 or later (included)
- Home Assistant Core 2024.1 or later

### Features with Home Assistant
- Control playback from Home Assistant dashboard
- Automation support (play music based on triggers)
- Multi-room audio control
- Volume management
- Media browsing and library access
- TTS (Text-to-Speech) integration

## First Run Setup

1. Access Music Assistant at `http://umbrel.local:3005`
2. Complete the initial setup wizard
3. Connect your streaming services (Spotify, YouTube Music, etc.)
4. Add your players (Sonos, Google Cast, etc.)
5. Optional: Add local music files to `${APP_DATA_DIR}/media`

## Local Music Files

To add your local music library:

1. Copy your music files to the `${APP_DATA_DIR}/media` directory on your Umbrel
2. In Music Assistant web interface, go to Settings → Music Providers
3. Add "Filesystem" provider
4. Point it to `/media` (this is the path inside the container)
5. Music Assistant will scan and index your files

## Network Discovery

Music Assistant uses mDNS/uPnP for automatic player discovery. Most players will be automatically detected on your local network. If you experience discovery issues:

- Ensure your Umbrel and players are on the same network
- Check firewall settings
- Some advanced network setups (VLANs) may require additional configuration

## Troubleshooting

### Players not appearing
- Verify players are on the same network as Umbrel
- Restart Music Assistant
- Check player-specific requirements (some may need additional setup)

### Home Assistant not discovering Music Assistant
- Ensure Home Assistant and Umbrel are on the same network
- Manually add integration using `http://umbrel.local:3005`
- Check that port 8097 is accessible from Home Assistant

### Streaming issues
- Verify streaming port 8097 is not blocked by firewall
- Check network bandwidth
- Ensure streaming service accounts are properly authenticated

## Notes

- Music Assistant requires streaming service subscriptions for most providers (Spotify Premium, etc.)
- Local music playback does not require any subscriptions
- For best performance, ensure your Umbrel has stable network connectivity
- Multi-room sync requires compatible players (Sonos, Snapcast, etc.)
