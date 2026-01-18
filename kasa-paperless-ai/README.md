# Paperless-AI

AI-powered extension for Paperless-ngx that brings automatic document
classification, smart tagging, and semantic search using LLMs.

## Features

- **Automatic Classification** - AI-powered document analysis and categorization
- **Smart Tagging** - Intelligent tag suggestions based on document content
- **Correspondent Detection** - Automatically identify senders and recipients
- **RAG-Powered Chat** - Search your documents using natural language queries
- **Multiple LLM Support** - Works with Ollama, OpenAI, Azure, and Deepseek-r1

## Links

- Website: https://clusterzx.github.io/paperless-ai/
- Documentation: https://github.com/clusterzx/paperless-ai/wiki
- Repository: https://github.com/clusterzx/paperless-ai
- Issues: https://github.com/clusterzx/paperless-ai/issues

## Prerequisites

- A running Paperless-ngx instance
- An LLM provider (Ollama on Umbrel or OpenAI API key)

## Configuration

| Setting | Value |
|---------|-------|
| Web UI | `http://umbrel.local:3001` |
| Default Port | 3001 |

### Data Volumes

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `${APP_DATA_DIR}` | `/app/data` | Configuration and database |

## Getting Started

1. Install the app from the Kasa community store
2. Access the web interface at `http://umbrel.local:3001`
3. Complete the setup wizard:
   - Enter your Paperless-ngx URL (e.g., `http://umbrel.local:8000`)
   - Enter your Paperless-ngx API token
   - Configure your LLM provider (Ollama or OpenAI)
4. Set up the scan interval for automatic processing
5. Restart the container after initial setup to build the RAG index

## LLM Configuration

### Using Ollama (Recommended for Privacy)

If you have Ollama installed on Umbrel:
- Ollama Host: `http://umbrel.local:11434`
- Recommended models: `mistral`, `llama3`, `phi3`, `gemma2`

### Using OpenAI

- Provide your OpenAI API key in the setup wizard
- Select your preferred model (e.g., `gpt-4o`, `gpt-3.5-turbo`)

## Notes

- RAG (Retrieval-Augmented Generation) is disabled by default
- First-time install: restart the container after completing setup to build the RAG index
- The default scan interval is 30 minutes
