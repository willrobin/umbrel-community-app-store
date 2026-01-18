# Music Assistant

Music Assistant ist ein freier, quelloffener Musik-Bibliotheksmanager, der deine Streaming-Dienste und lokalen Musikdateien mit einer Vielzahl von vernetzten Lautsprechern verbindet.

## Features

- **Unified Music Library** – Verbindet Spotify, Tidal, YouTube Music, Qobuz, lokale Dateien und mehr
- **Multi-Room Audio** – Streame zu Sonos, Chromecast, AirPlay, DLNA, Snapcast und vielen anderen
- **Playlist-Synchronisation** – Erstelle und verwalte Playlists über alle Musikquellen hinweg
- **Home Assistant Integration** – Nahtlose Integration für Smart-Home-Automatisierung

## Zugriff

Nach der Installation ist Music Assistant über Port **8095** erreichbar.

## Hinweise

- Music Assistant nutzt **Host-Netzwerk-Modus** für die Player-Erkennung (Layer-2 Netzwerkzugriff erforderlich)
- Es gibt **keinen Login-Screen** – die App sollte nicht direkt ins Internet exponiert werden
- Lokale Musikdateien können im Verzeichnis `/media` innerhalb des Containers abgelegt werden

## Musik hinzufügen

1. Lege deine Musikdateien im App-Datenverzeichnis unter `media/` ab
2. Oder verbinde Streaming-Dienste wie Spotify, Tidal, YouTube Music direkt in der Web-Oberfläche

## Links

- [Offizielle Website](https://www.music-assistant.io)
- [GitHub Repository](https://github.com/music-assistant/server)
- [Dokumentation](https://www.music-assistant.io/installation/)
