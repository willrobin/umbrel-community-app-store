# Paperless-GPT

AI-powered companion for Paperless-ngx that enhances OCR with LLMs and
automatically suggests titles, tags, correspondents, document types, and
custom fields.

## Features

- **LLM-Enhanced OCR** - Use vision LLMs for superior OCR on difficult scans
- **Auto Suggestions** - Automatic title, tag, and correspondent proposals
- **Document Types** - Intelligent document type classification
- **Custom Prompts** - Customize how the AI processes your documents
- **Review Interface** - Web UI to review and approve suggestions
- **Multiple Providers** - Works with OpenAI, Ollama, Google Gemini, and more

## Links

- Repository: https://github.com/icereed/paperless-gpt
- Docker Hub: https://hub.docker.com/r/icereed/paperless-gpt
- Issues: https://github.com/icereed/paperless-gpt/issues

## Prerequisites

- A running Paperless-ngx instance
- An LLM provider (Ollama on Umbrel or OpenAI/Gemini API key)
- Paperless-ngx API token

## Configuration

| Setting | Value |
|---------|-------|
| Web UI | `http://umbrel.local:3003` |
| Default Port | 3003 |

### Required Environment Variables

Before starting, configure these in the docker-compose.yml:

| Variable | Description | Example |
|----------|-------------|---------|
| `PAPERLESS_BASE_URL` | Paperless-ngx URL | `http://umbrel.local:2349` |
| `PAPERLESS_API_TOKEN` | Your API token | Get from Paperless-ngx settings |
| `LLM_PROVIDER` | LLM provider | `ollama`, `openai`, `gemini` |
| `LLM_MODEL` | Model name | `qwen2.5:7b`, `gpt-4o`, `gemini-pro` |
| `OLLAMA_HOST` | Ollama URL (if using) | `http://umbrel.local:11434` |

The compose file in this repository intentionally contains placeholder values
(`CHANGE_ME`) for secrets. Never commit real tokens.

### Data Volumes

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `${APP_DATA_DIR}/prompts` | `/app/prompts` | Custom prompts |
| `${APP_DATA_DIR}/db` | `/app/db` | Local database |

## Getting Started

1. Install the app from the Kasa community store
2. Get your Paperless-ngx API token from Settings > API
3. Set your token/provider settings in your runtime deployment (for example via Compose Patcher), not in this Git repository
4. Restart the app
5. Access the web interface at `http://umbrel.local:3003`

## How It Works

1. Tag documents in Paperless-ngx with the trigger tag (default: `paperless-gpt`)
2. Paperless-GPT processes the document using your LLM
3. Review suggestions in the web interface
4. Approve to apply changes to Paperless-ngx

## Automatic Mode

Set `AUTO_TAG: "paperless-gpt-auto"` to enable automatic processing:
- Documents with this tag are processed automatically
- Suggestions are applied without manual review

## Notes

- The default configuration uses Ollama with `qwen2.5:7b` model
- Vision LLM support enables better OCR for scanned documents
- Custom prompts can be stored in the prompts directory
