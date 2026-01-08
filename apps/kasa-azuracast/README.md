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
  - `${APP_DATA_DIR}/stations` -> `/var/azuracast/stations` (Station data and media)
  - `${APP_DATA_DIR}/backups` -> `/var/azuracast/backups` (Backup storage)
  - `${APP_DATA_DIR}/uploads` -> `/var/azuracast/storage/uploads` (User uploads)
  - `${APP_DATA_DIR}/sftpgo` -> `/var/azuracast/storage/sftpgo` (SFTP configuration)
  - `${APP_DATA_DIR}/geoip` -> `/var/azuracast/storage/geoip` (Geolocation data)
  - `${APP_DATA_DIR}/acme` -> `/var/azuracast/storage/acme` (SSL certificates)
  - `${APP_DATA_DIR}/db` -> `/var/lib/mysql` (Database)
  - `${APP_DATA_DIR}/redis` -> `/data` (Redis cache)

## Notes
- AzuraCast manages station streaming internally. If you need external access
  to radio ports for non-web clients, the default compose exposes ports
  20000-20050 for station streams.
- To change the stream port range, update the `ports` mapping in
  `apps/kasa-azuracast/docker-compose.yml` and adjust AzuraCast's port range
  settings as described in the upstream Docker docs.
- The database credentials are internal defaults. Change them if you plan to
  expose the database outside Umbrel.
