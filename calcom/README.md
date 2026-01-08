# Cal.com

Cal.com is an open-source scheduling platform for individuals and teams. Create
booking pages, manage availability, and coordinate meetings with flexible
workflows.

## Links
- Upstream: https://github.com/calcom/cal.com
- Docs: https://cal.com/docs
- Issues: https://github.com/calcom/cal.com/issues

## Configuration
- App UI: http://umbrel.local:3000
- Default port: 3000
- Data volumes:
  - `${APP_DATA_DIR}/calcom/db` -> `/var/lib/postgresql/data`
  - `${APP_DATA_DIR}/calcom/redis` -> `/data`
- Required environment:
  - `NEXTAUTH_URL` (public URL for the Umbrel app)
  - `NEXTAUTH_SECRET` (set a strong random string)
  - `CALENDSO_ENCRYPTION_KEY` (set a strong random string)

## Notes
- Update the secrets before exposing Cal.com publicly.
- The database credentials are internal defaults; change them if you plan to
  expose the database outside Umbrel.
