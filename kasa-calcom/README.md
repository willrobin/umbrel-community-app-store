# Cal.com

Cal.com is an open-source scheduling platform for individuals and teams. Create
booking pages, manage availability, and coordinate meetings with flexible
workflows.

## Links
- Upstream: https://github.com/calcom/cal.com
- Docs: https://cal.com/docs
- Issues: https://github.com/calcom/cal.com/issues

## Configuration
- App UI: http://umbrel.local:3002
- Default port: 3002
- Data volumes:
  - `${APP_DATA_DIR}/db` -> `/var/lib/postgresql/data`
  - `${APP_DATA_DIR}/redis` -> `/data`
- Required environment:
  - `NEXTAUTH_URL` (public URL for the Umbrel app, default uses `$DEVICE_DOMAIN_NAME`)
  - `NEXTAUTH_SECRET` (defaults to `$APP_SEED`)
  - `CALENDSO_ENCRYPTION_KEY` (defaults to `$APP_SEED`)

## Notes
- Update the secrets before exposing Cal.com publicly if you don't want to use
  `$APP_SEED`.
- The database credentials are internal defaults; change them if you plan to
  expose the database outside Umbrel.
