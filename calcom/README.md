# Cal.com

## Overview
Cal.com is an open-source scheduling platform for individuals and teams. Create
booking pages, manage availability, and coordinate meetings with flexible
workflows.

## Configuration
- Ports: 3000
- Volumes:
  - `${APP_DATA_DIR}/calcom/db` -> Postgres data
  - `${APP_DATA_DIR}/calcom/redis` -> Redis data
- Environment:
  - `NEXTAUTH_URL`: Public URL for the Umbrel app (default: `http://umbrel.local:3000`)
  - `NEXTAUTH_SECRET`: Replace with a strong random string before exposing Cal.com
  - `CALENDSO_ENCRYPTION_KEY`: Replace with a strong random string before use

## Notes
- The database credentials are internal defaults. Change them if you plan to
  expose the database outside Umbrel.
