# Paperless-GPT

AI-powered companion for paperless-ngx that enhances OCR with LLMs and
automatically suggests titles, tags, correspondents, and custom fields.

## Links
- Upstream: https://github.com/icereed/paperless-gpt
- Issues: https://github.com/icereed/paperless-gpt/issues

## Required Configuration
Set the following environment variables in `docker-compose.yml` before starting:
- `PAPERLESS_BASE_URL` (paperless-ngx base URL, e.g. `http://umbrel.local:2349`)
- `PAPERLESS_API_TOKEN` (paperless-ngx API token)
- `LLM_PROVIDER`, `LLM_MODEL`, `OLLAMA_HOST` (or configure a different LLM provider)

## Persistence
- Prompts: `${APP_DATA_DIR}/paperless-gpt/prompts` -> `/app/prompts`
- Local DB: `${APP_DATA_DIR}/paperless-gpt/db` -> `/app/db`
