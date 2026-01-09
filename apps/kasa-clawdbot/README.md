# ClawdBot

ClawdBot is your own personal AI assistant that runs on your own devices. It provides a local-first, fast, and always-on assistant experience with integration to popular messaging platforms.

## Features

- **Multi-Platform Messaging**: Integrate with WhatsApp, Telegram, Slack, Discord, Signal, iMessage, and WebChat
- **Local-First Architecture**: Your data stays under your control
- **AI Provider Support**: Works with Anthropic Claude (Pro/Max) and OpenAI models
- **Voice Capabilities**: Optional voice features with ElevenLabs integration
- **Live Canvas Interface**: Interactive visual interface for agent interactions
- **Sandboxed Execution**: Safe tool execution in isolated Docker containers
- **Comprehensive Skills System**: Extensible skill framework for custom capabilities
- **Session Management**: Persistent sessions with context awareness

## Configuration

### Ports

- **Gateway WebSocket**: 18789 (UI Access)
- **Bridge TCP**: 18790 (Internal Communication)

### Volumes

- `${APP_DATA_DIR}/config` - Configuration and credentials (`~/.clawdbot/`)
- `${APP_DATA_DIR}/workspace` - Agent workspace and skills (`~/clawd/`)

### Initial Setup

1. **Install the app** from your Umbrel App Store

2. **Configure AI Provider** - Create or edit the configuration file at:
   ```
   ${APP_DATA_DIR}/config/clawdbot.json
   ```

   Example configuration:
   ```json
   {
     "agent": {
       "model": "anthropic/claude-opus-4-5"
     }
   }
   ```

3. **Add API Credentials** - Set up authentication for your chosen AI provider:

   **For Anthropic Claude:**
   - Obtain Claude Pro/Max subscription or API key
   - Add credentials to `${APP_DATA_DIR}/config/credentials`

   **For OpenAI:**
   - Obtain OpenAI API key
   - Configure in the credentials file

4. **Configure Messaging Providers** (Optional) - To enable messaging platform integrations, add the respective bot tokens to your configuration:

   - **Telegram**: `TELEGRAM_BOT_TOKEN`
   - **Slack**: `SLACK_BOT_TOKEN`
   - **Discord**: `DISCORD_BOT_TOKEN`
   - **Signal**: Signal setup as documented
   - **WhatsApp**: WhatsApp Business API credentials

### Security & Pairing

By default, ClawdBot treats unknown senders as untrusted. New contacts receive a pairing code and require approval:

```bash
clawdbot pairing approve <contact-id>
```

For group and channel interactions, consider enabling the sandbox feature to isolate execution from the host system.

## Usage

### Basic Commands

Once configured, you can interact with ClawdBot through:

1. **Web Interface**: Access at `http://your-umbrel:3006`
2. **Messaging Platforms**: Send messages through configured platforms
3. **CLI**: Connect to the gateway via command-line tools

### Built-in Commands

- `/status` - View session info and token usage
- `/new` - Reset current session
- `/think <level>` - Adjust reasoning depth (low/medium/high)
- `/restart` - Restart the gateway (admin only)

### Skills System

ClawdBot includes an extensible skills framework. Custom skills can be added to the workspace directory:

```
${APP_DATA_DIR}/workspace/skills/
```

Refer to the [ClawdBot documentation](https://github.com/clawdbot/clawdbot) for skill development guidelines.

## Environment Variables

- `NODE_ENV` - Set to `production` for optimal performance
- `HOME` - Home directory for configuration (`/home/node`)

## Advanced Configuration

### Voice Features

To enable voice capabilities, configure ElevenLabs integration in your configuration file:

```json
{
  "voice": {
    "provider": "elevenlabs",
    "apiKey": "your-api-key"
  }
}
```

### Remote Access

For secure remote access, consider using:
- **Tailscale**: VPN mesh networking for secure remote connections
- **SSH Tunnels**: Standard SSH port forwarding to the gateway

### Sandbox Mode

Enable sandbox mode for enhanced security when running untrusted tools or group interactions:

```json
{
  "agent": {
    "sandbox": true
  }
}
```

## Troubleshooting

### Gateway Won't Start

1. Check logs: `docker logs kasa-clawdbot_gateway_1`
2. Verify configuration file syntax: `${APP_DATA_DIR}/config/clawdbot.json`
3. Ensure AI provider credentials are correctly set

### Messaging Platform Not Connecting

1. Verify bot tokens are correctly configured
2. Check that the respective platform's bot is properly set up
3. Review security settings and pairing requirements

### Performance Issues

1. Adjust thinking level with `/think low` for faster responses
2. Check AI provider rate limits and quota
3. Monitor token usage with `/status`

## Data Persistence

All configuration and workspace data is stored in:
- **Configuration**: `${APP_DATA_DIR}/config/`
- **Workspace**: `${APP_DATA_DIR}/workspace/`

Ensure regular backups of these directories to preserve your settings and skills.

## Notes

- ClawdBot requires a valid Anthropic Claude or OpenAI API subscription
- First startup may take 1-2 minutes while the npm package is installed
- Gateway runs on all interfaces (0.0.0.0) for Umbrel app_proxy compatibility
- Session state is maintained locally for fast context access

## Resources

- **GitHub**: https://github.com/clawdbot/clawdbot
- **Documentation**: https://github.com/clawdbot/clawdbot/tree/main/docs
- **Issues**: https://github.com/clawdbot/clawdbot/issues
- **Discussions**: https://github.com/clawdbot/clawdbot/discussions

## Version

Current version: **2026.1.8-2**

This release includes NPM package fixes and containerized gateway/CLI setup for improved deployment reliability.
