# Paperless-AI

Paperless-AI is an AI-powered extension for Paperless-ngx that automates document processing using large language models. Enhance your document management with intelligent classification, smart tagging, and semantic search.

## Features

- Automatic document classification based on content
- Smart tagging with AI-generated suggestions
- Semantic search across your document library
- Support for OpenAI-compatible APIs and Ollama
- RAG (Retrieval Augmented Generation) for contextual queries
- Custom prompt templates for specialized workflows
- Batch processing for existing documents
- Privacy-focused with local LLM support

## Links

- **Repository:** https://github.com/clusterzx/paperless-ai
- **Documentation:** https://github.com/clusterzx/paperless-ai/wiki
- **Support:** https://github.com/clusterzx/paperless-ai/issues

## Prerequisites

Before installing Paperless-AI, ensure you have:

1. **Paperless-ngx** installed and running on your Umbrel
2. **LLM Provider** - one of the following:
   - [Ollama](https://apps.umbrel.com/app/ollama) (recommended for privacy)
   - OpenAI API key
   - Any OpenAI-compatible API

## Access

| Service | URL |
|:--------|:----|
| Web UI | `http://umbrel.local:3001` |

## Initial Setup

1. Install and start Paperless-AI
2. Open the web interface at `http://umbrel.local:3001`
3. Complete the setup wizard:
   - Enter your Paperless-ngx URL and API token
   - Configure your LLM provider (Ollama or OpenAI)
   - Set up your classification rules and tags

### Connecting to Paperless-ngx

You'll need your Paperless-ngx API token:

1. Open Paperless-ngx settings
2. Navigate to "Token Management"
3. Create a new token and copy it to Paperless-AI

### Data Storage

| Volume | Path |
|:-------|:-----|
| Configuration & data | `${APP_DATA_DIR}/data` |

## Security

- Runs as non-root user (UID 1000)
- All capabilities dropped
- No privilege escalation allowed

## Notes

- RAG service is disabled by default; enable it only if you run a separate RAG service
- For best results with Ollama, use models like `llama3.1:8b` or `mistral:7b`
- Batch processing of existing documents is available in settings

## Developer

**Clusterzx** - https://github.com/clusterzx

---

*Submitted by [Kasa](https://github.com/willrobin/umbrel-community-app-store)*
