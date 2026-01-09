# ClawdBot for Umbrel

ClawdBot is your own personal AI assistant that runs on your own devices. It provides a local-first, fast, and always-on AI assistant experience with seamless integration across multiple messaging platforms.

## Features

### Multi-Platform Messaging Integration
Connect ClawdBot to your favorite messaging platforms:
- WhatsApp
- Telegram
- Slack
- Discord
- Signal
- iMessage
- WebChat (built-in web interface)

### AI Model Support
- **Anthropic Claude**: Claude 3.5 Sonnet, Claude Opus, and more
- **OpenAI**: GPT-4, GPT-3.5 Turbo, and other models

### Advanced Capabilities
- **Voice Support**: Integration with ElevenLabs for voice interactions
- **Live Canvas**: Interactive interface for real-time collaboration
- **Sandboxed Tool Execution**: Safe execution of tools in Docker containers
- **Skills System**: Extensible skills for custom functionality
- **Session Management**: Persistent conversations across sessions
- **Local-First**: Your data stays under your control on your device

## Configuration

### Network Ports
- **Port 3006**: Web UI (via Umbrel app proxy)
- **Port 18789**: Gateway WebSocket (internal)
- **Port 18790**: Bridge TCP (internal messaging)

### Data Storage
ClawdBot stores data in two main locations:
- **Config**: `${APP_DATA_DIR}/config` - Configuration files and credentials (~/.clawdbot/)
- **Workspace**: `${APP_DATA_DIR}/workspace` - Skills and session data (~/clawd/)

## Setup

### 1. Install the App
Install ClawdBot from your Umbrel App Store.

### 2. Configure AI Provider
After installation, you'll need to configure your preferred AI provider:

**For Anthropic Claude:**
1. Get your API key from https://console.anthropic.com/
2. Add it to the configuration file at `${APP_DATA_DIR}/config/clawdbot.json`

**For OpenAI:**
1. Get your API key from https://platform.openai.com/
2. Add it to the configuration file

Example configuration:
```json
{
  "provider": "anthropic",
  "anthropic": {
    "apiKey": "your-api-key-here"
  }
}
```

### 3. Set Up Messaging Platforms (Optional)
To use ClawdBot with messaging platforms, you'll need to configure the appropriate tokens and webhooks for each service. See the [ClawdBot documentation](https://github.com/clawdbot/clawdbot) for platform-specific setup instructions.

### 4. Security & Pairing
Configure security settings and pair your devices as needed. The built-in web interface allows you to manage connections and sessions.

## Usage

### Web Interface
Access ClawdBot's web interface at:
```
http://your-umbrel-address:3006
```

### Built-in Commands
- `/new` - Start a new conversation session
- `/think` - Adjust reasoning depth
- `/status` - View system status
- `/restart` - Restart the gateway

### Voice Support
Enable voice capabilities by configuring ElevenLabs integration in the settings.

### Skills & Extensions
ClawdBot supports custom skills for extended functionality. Skills are stored in the workspace directory and can be managed through the web interface.

## Troubleshooting

### Connection Issues
- Verify that ports 18789 and 18790 are not blocked
- Check that the gateway service is running: `docker logs kasa-clawdbot_gateway_1`

### API Configuration
- Ensure your API keys are correctly configured in `clawdbot.json`
- Verify you have sufficient API credits with your provider

### Data Persistence
All configuration and conversation data is stored in `${APP_DATA_DIR}` and persists across container restarts.

### Remote Access
Access ClawdBot remotely via:
- Tailscale (if configured on your Umbrel)
- SSH tunnel to your Umbrel device

## Resources

- **Official Repository**: https://github.com/clawdbot/clawdbot
- **Issue Tracker**: https://github.com/clawdbot/clawdbot/issues
- **Version**: 2026.1.8-2

## Notes

- ClawdBot requires an active internet connection to communicate with AI providers
- API usage is billed by your chosen provider (Anthropic or OpenAI)
- The sandbox mode provides safe execution of tools within Docker containers
- All data remains under your control on your Umbrel device
