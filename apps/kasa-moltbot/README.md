# Moltbot for Umbrel

Personal AI assistant with multi-channel messaging support.

## About

Moltbot is an open-source personal AI assistant that runs on your own devices. It supports multiple messaging channels (WhatsApp, Telegram, Slack, Discord, Signal, iMessage, Microsoft Teams, Matrix, and more) through a single WebSocket-based Gateway control plane.

## Features

- **Multi-Channel Messaging**: Connect WhatsApp, Telegram, Slack, Discord, Signal, iMessage, Teams, Matrix, and more
- **AI Models**: Supports Anthropic Claude and OpenAI models with automatic failover
- **WebChat & Control UI**: Browser-based interface for direct interaction
- **Voice Interaction**: ElevenLabs integration for speech
- **Browser Automation**: Chrome DevTools Protocol integration
- **Agent Mode**: Autonomous task execution
- **DM Pairing**: Secure access control for messaging channels

## Configuration

After installing Moltbot on your Umbrel, you need to configure your AI model API keys. Edit the configuration file at the app's data directory:

### Setting up API Keys

1. Open the Moltbot WebChat UI via your Umbrel dashboard
2. Configure your preferred AI provider:
   - **Anthropic Claude**: Set your API key or session key
   - **OpenAI**: Set your API key
3. Connect your messaging channels through the Control UI

### Gateway Token

The Gateway token is automatically generated from your Umbrel app seed for secure access.

## Ports

| Port  | Service          |
|-------|------------------|
| 3006  | Gateway (Web UI) |

## Links

- **Source Code**: https://github.com/moltbot/moltbot
- **Issues**: https://github.com/moltbot/moltbot/issues
- **License**: MIT
