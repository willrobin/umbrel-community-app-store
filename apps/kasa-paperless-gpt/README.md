# Paperless-GPT

Paperless-GPT is an AI-powered companion for Paperless-ngx that enhances document processing using large language models. It automatically suggests titles, tags, correspondents, and custom fields based on document content.

## Features

- Enhanced OCR with LLM post-processing
- Automatic title generation from content
- Smart tag suggestions based on document context
- Correspondent detection and assignment
- Custom field extraction and population
- Support for Ollama, OpenAI, and Anthropic Claude
- Automatic document type assignment
- Customizable prompt templates
- Manual and automatic processing modes

## Links

- **Repository:** https://github.com/icereed/paperless-gpt
- **Support:** https://github.com/icereed/paperless-gpt/issues

## Prerequisites

Before installing Paperless-GPT, ensure you have:

1. **Paperless-ngx** installed and running on your Umbrel
2. **LLM Provider** - one of the following:
   - [Ollama](https://apps.umbrel.com/app/ollama) (default, recommended for privacy)
   - OpenAI API key
   - Anthropic Claude API key

## Access

| Service | URL |
|:--------|:----|
| Web UI | `http://umbrel.local:3003` |

## Configuration

### Required Setup After Installation

1. **Get your Paperless-ngx API token:**
   - Open Paperless-ngx settings
   - Navigate to "Token Management"
   - Create a new token

2. **Update the configuration:**
   - Edit the docker-compose.yml or use Umbrel's environment variable editor
   - Replace `CHANGE_ME` with your actual Paperless-ngx API token

### Environment Variables

| Variable | Description | Default |
|:---------|:------------|:--------|
| `PAPERLESS_BASE_URL` | Paperless-ngx URL | `http://umbrel.local:2349` |
| `PAPERLESS_API_TOKEN` | API token from Paperless-ngx | `CHANGE_ME` |
| `LLM_PROVIDER` | LLM backend (ollama/openai/anthropic) | `ollama` |
| `LLM_MODEL` | Model to use | `llama3.1:8b` |
| `OLLAMA_HOST` | Ollama server URL | `http://umbrel.local:11434` |
| `MANUAL_TAG` | Tag for manual processing | `paperless-gpt` |
| `AUTO_TAG` | Tag for automatic processing | `paperless-gpt-auto` |

### Using Different LLM Providers

**OpenAI:**
```yaml
LLM_PROVIDER: "openai"
LLM_MODEL: "gpt-4o-mini"
OPENAI_API_KEY: "your-api-key"
```

**Anthropic Claude:**
```yaml
LLM_PROVIDER: "anthropic"
LLM_MODEL: "claude-3-haiku-20240307"
ANTHROPIC_API_KEY: "your-api-key"
```

### Data Storage

| Volume | Path |
|:-------|:-----|
| Custom prompts | `${APP_DATA_DIR}/data/prompts` |
| Local database | `${APP_DATA_DIR}/data/db` |

## How It Works

1. Tag a document in Paperless-ngx with `paperless-gpt` (manual) or `paperless-gpt-auto` (automatic)
2. Paperless-GPT processes the document with your configured LLM
3. The LLM suggests title, tags, correspondent, and custom fields
4. Review and approve suggestions (manual) or auto-apply (automatic)

## Notes

- Default configuration uses Ollama on the standard Umbrel port (11434)
- For best results, use capable models like `llama3.1:8b` or better
- Custom prompt templates can be edited in the prompts volume

## Developer

**Icereed** - https://github.com/icereed

---

*Submitted by [Kasa](https://github.com/willrobin/umbrel-community-app-store)*
