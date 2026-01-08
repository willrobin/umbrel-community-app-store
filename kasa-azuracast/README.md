# AzuraCast

AzuraCast is a self-hosted, all-in-one web radio management suite. Run multiple
stations, manage media libraries, and stream to listeners from a single
dashboard.

## Links
- Upstream: https://github.com/AzuraCast/AzuraCast
- Docs: https://docs.azuracast.com/
- Issues: https://github.com/AzuraCast/AzuraCast/issues

## Configuration
- App UI: http://umbrel.local:3004
- Default port: 3004
- Data volumes:
  - `${APP_DATA_DIR}/azuracast` -> `/var/azuracast`
  - `${APP_DATA_DIR}/azuracast/db` -> `/var/lib/mysql`
  - `${APP_DATA_DIR}/azuracast/redis` -> `/data`

## Notes
- AzuraCast manages station streaming internally. If you need external access
  to radio ports for non-web clients, add explicit port mappings in
  `apps/kasa-azuracast/docker-compose.yml`.
- The database credentials are internal defaults. Change them if you plan to
  expose the database outside Umbrel.
