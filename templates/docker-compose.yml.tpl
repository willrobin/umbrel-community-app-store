version: "3.7"

services:
  app_proxy:
    environment:
      # Format: <app-id>_<docker-service-name>_1
      APP_HOST: __APP_ID___server_1
      APP_PORT: __APP_PORT__

  server:
    image: __IMAGE__
    user: "1000:1000"
    init: true
    restart: unless-stopped
    volumes:
      - ${APP_DATA_DIR}/data:/data
