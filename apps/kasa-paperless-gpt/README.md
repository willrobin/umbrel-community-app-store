# Paperless-GPT

AI-powered companion for paperless-ngx that enhances OCR with LLMs and
automatically suggests titles, tags, correspondents, and custom fields.

## Links
- Upstream: https://github.com/icereed/paperless-gpt
- Issues: https://github.com/icereed/paperless-gpt/issues

## Required Configuration
Set the following environment variables in `docker-compose.yml` before starting:
- `PAPERLESS_BASE_URL` (paperless-ngx base URL)
- `PAPERLESS_API_TOKEN` (paperless-ngx API token)
- `OPENAI_API_KEY` (or configure your preferred LLM provider)

## Persistence
- Prompts: `${APP_DATA_DIR}/paperless-gpt/prompts` -> `/app/prompts`
- Local DB: `${APP_DATA_DIR}/paperless-gpt/db` -> `/app/db`
