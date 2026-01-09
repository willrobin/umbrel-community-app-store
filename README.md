# Kasa Umbrel Community App Store (傘)

Kasa (傘) bedeutet "Regenschirm" auf Japanisch und spielt auf Umbrels Schirm-Logo an. Dieser Store ist ein unabhängiger Community App Store und nicht mit dem offiziellen Umbrel Team verbunden.

## Aktuell verfügbare Apps

| # | Logo | App | Beschreibung | Port |
| :-: | :-: | :-- | :-- | :-: |
| 1 | <img height="28" src="apps/kasa-azuracast/icon.png" /> | [AzuraCast](apps/kasa-azuracast) | Self-hosted Radio-Streaming und Stationsverwaltung | 3004 |
| 2 | <img height="28" src="https://cal.com/android-chrome-512x512.png" /> | [Cal.com](apps/kasa-calcom) | Open-source Scheduling für Teams und Einzelpersonen | 3002 |
| 3 | <img height="28" src="https://raw.githubusercontent.com/clawdbot/clawdbot/main/README-header.png" /> | [ClawdBot](apps/kasa-clawdbot) | Personal AI Assistant mit Multi-Plattform-Messaging | 3006 |
| 4 | <img height="28" src="https://raw.githubusercontent.com/willrobin/umbrel-community-app-store/main/kasa-music-assistant/icon.png" /> | [Music Assistant](apps/kasa-music-assistant) | Musik-Bibliothek-Manager mit Streaming-Service-Integration | 3005 |
| 5 | <img height="28" src="https://raw.githubusercontent.com/clusterzx/paperless-ai/main/icon.png" /> | [Paperless-AI](apps/kasa-paperless-ai) | AI-Tagging und RAG-Suche für Paperless-ngx | 3001 |
| 6 | <img height="28" src="apps/kasa-paperless-gpt/icon.png" /> | [Paperless-GPT](apps/kasa-paperless-gpt) | LLM-gestützte OCR und Tagging für Paperless-ngx | 3003 |

## Hinweise zu Abhängigkeiten
- ClawdBot benötigt einen API-Key von Anthropic Claude oder OpenAI.
- Paperless-AI und Paperless-GPT benötigen eine laufende Paperless-ngx Instanz.
- Für AI-Funktionen wird ein LLM Provider benötigt (z. B. Ollama oder OpenAI). Siehe die jeweiligen App-READMEs.

## App Store hinzufügen
1) Umbrel UI öffnen -> App Store -> Community App Stores.
2) Diese Repo-URL hinzufügen.
3) Apps installieren wie gewohnt.

Demo: https://user-images.githubusercontent.com/10330103/197889452-e5cd7e96-3233-4a09-b475-94b754adc7a3.mp4

## Ports und Konflikte
- Kasa nutzt die UI-Ports 3001-3006.
- AzuraCast öffnet zusätzlich Streaming-Ports 20000-20050.
- Music Assistant nutzt zusätzlich Port 8097 für den Streaming-Server.
- ClawdBot nutzt zusätzlich Ports 18789 (Gateway) und 18790 (Bridge).
- Abgleich mit Denny's Umbrel Community App Store (Stand 2026-01-08): keine Konflikte für 3001-3006; der AzuraCast-Range wurde bewusst außerhalb der dort genutzten 8xxx-Ports gelegt.

## Datenpfade und Variablen
- App-Daten liegen unter `${APP_DATA_DIR}` (Umbrel setzt dies pro App).
- In den Compose-Dateien verwenden wir `${APP_DATA_DIR}` als Standard.

## Entwicklung / Workflow
1) `./scripts/new-app.sh <app-id> "<App Name>"`
2) App-Dateien bearbeiten in `apps/<app-id>/`.
3) `./scripts/publish.sh`
4) `./scripts/validate.sh`

## Beitrag und Support
- App-Ideen und Issues gern via GitHub.
- Bitte keine Secrets in Compose oder Repo ablegen.
