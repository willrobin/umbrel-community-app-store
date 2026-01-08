# Paperless-AI

AI-powered extension for Paperless-ngx that adds automatic document
classification, smart tagging, and semantic search.

## Links
- Upstream: https://github.com/clusterzx/paperless-ai
- Issues: https://github.com/clusterzx/paperless-ai/issues
- Install guide: https://github.com/clusterzx/paperless-ai/wiki/2.-Installation

## Configuration
- App UI: http://umbrel.local:3001
- Default port: 3001
- Data volume: `${APP_DATA_DIR}` -> `/app/data`

## Notes
Complete the in-app setup after first start. See the upstream install guide for
required API keys and Paperless-ngx connection details.
RAG is disabled by default in this Umbrel compose; enable it only if you run a
separate RAG service and update the env vars accordingly.
