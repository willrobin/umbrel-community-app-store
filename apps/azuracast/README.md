# AzuraCast

## Overview
AzuraCast is a self-hosted, all-in-one web radio management suite. Run multiple
stations, manage media libraries, and stream to listeners from a single
dashboard.

## Configuration
- Ports: 80
- Volumes:
  - `${APP_DATA_DIR}/azuracast` -> AzuraCast data
  - `${APP_DATA_DIR}/azuracast/db` -> MariaDB data
  - `${APP_DATA_DIR}/azuracast/redis` -> Redis data

## Notes
- AzuraCast manages station streaming internally. If you need external access
  to radio ports for non-web clients, add explicit port mappings in
  `apps/azuracast/docker-compose.yml`.
- The database credentials are internal defaults. Change them if you plan to
  expose the database outside Umbrel.
