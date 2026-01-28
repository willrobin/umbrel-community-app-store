# Moltbot for Umbrel

Personal AI assistant with multi-channel messaging support.

## About

Moltbot is an open-source personal AI assistant that runs on your own devices. It supports multiple messaging channels (WhatsApp, Telegram, Slack, Discord, Signal, iMessage, Microsoft Teams, Matrix, and more) through a single WebSocket-based Gateway control plane.

## Features

- **Multi-Channel Messaging**: Connect WhatsApp, Telegram, Slack, Discord, Signal, iMessage, Teams, Matrix, and more
- **AI Models**: Supports Anthropic Claude and OpenAI models with automatic failover
- **WebChat & Control UI**: Browser-based interface for direct interaction and configuration
- **Voice Interaction**: ElevenLabs integration for text-to-speech
- **Browser Automation**: Chrome DevTools Protocol integration
- **Agent Mode**: Autonomous task execution with tool use
- **DM Pairing**: Secure access control for messaging channels
- **Plugin System**: Extensible architecture for custom integrations

## Configuration

After installing Moltbot on your Umbrel:

1. Open the Moltbot WebChat UI via your Umbrel dashboard (port 3007)
2. Configure your preferred AI provider:
   - **Anthropic Claude**: Set your API key or session key
   - **OpenAI**: Set your API key
3. Connect your messaging channels through the Control UI

The Gateway token is automatically generated from your Umbrel app seed (`${APP_SEED}`) for secure access.

## Ports

| Port | Service |
|------|---------|
| 3007 | Gateway (WebChat & Control UI) |

## Volumes

| Host Path | Container Path | Description |
|-----------|---------------|-------------|
| `${APP_DATA_DIR}/data` | `/home/node/.moltbot` | Configuration and state |
| `${APP_DATA_DIR}/workspace` | `/home/node/clawd` | Agent workspace |

## Architecture Support

This app uses `ghcr.io/moltbot/moltbot:main` which supports both AMD64 and ARM64.

## Troubleshooting

### Gateway shows "Missing config"

The `--allow-unconfigured` flag is set by default, so the Gateway should start without prior configuration. If you see this error, check that the data volume is writable.

### Cannot connect to messaging channels

Messaging channels require external network access. Ensure your Umbrel device has internet connectivity and the necessary ports are not blocked by a firewall.

## Links

- **Source Code**: https://github.com/moltbot/moltbot
- **Issues**: https://github.com/moltbot/moltbot/issues
- **License**: MIT
