# Cal.com

Cal.com is the open-source Calendly alternative for scheduling meetings and
appointments. Create beautiful booking pages, manage your availability, and
let others schedule time with you without the back-and-forth emails.

## Features

- **Booking Pages** - Create customizable scheduling pages for different event types
- **Calendar Sync** - Connect Google Calendar, Outlook, Apple Calendar, and more
- **Team Scheduling** - Coordinate availability across team members
- **Recurring Bookings** - Set up recurring appointment slots
- **Buffer Times** - Add breaks between meetings automatically
- **Workflow Automations** - Send reminders and follow-ups automatically

## Links

- Website: https://cal.com
- Documentation: https://cal.com/docs
- Repository: https://github.com/calcom/cal.com
- Issues: https://github.com/calcom/cal.com/issues

## Configuration

| Setting | Value |
|---------|-------|
| Web UI | `http://umbrel.local:3002` |
| Default Port | 3002 |

### Data Volumes

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `${APP_DATA_DIR}/db` | `/var/lib/postgresql/data` | PostgreSQL database |
| `${APP_DATA_DIR}/redis` | `/data` | Redis session store |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `NEXT_PUBLIC_WEBAPP_URL` | Public URL for the app (uses `${DEVICE_DOMAIN_NAME}:3002`) |
| `NEXTAUTH_URL` | Authentication URL (uses `${DEVICE_DOMAIN_NAME}:3002`) |
| `NEXTAUTH_SECRET` | Authentication secret (uses `${APP_SEED}`) |
| `CALENDSO_ENCRYPTION_KEY` | Encryption key (uses `${APP_SEED}`) |
| `DATABASE_URL` | PostgreSQL connection string |
| `REDIS_URL` | Redis connection string |

## Getting Started

1. Install the app from the Kasa community store
2. Access the web interface at `http://umbrel.local:3002`
3. Create your first user account
4. Set up your availability and create booking pages
5. Share your booking link with others

## Notes

- On first launch, a setup wizard will guide you through initial configuration
- Connect your external calendars to check availability automatically
- For public access, consider setting up a reverse proxy with SSL
- All secrets are derived from your Umbrel's secure app seed
- The first startup may take 2-3 minutes while database migrations run
- If the app doesn't start, wait a few minutes and try again - the database needs time to initialize

## Troubleshooting

If Cal.com fails to start:

1. **Wait for initialization**: The first startup requires database migrations which can take several minutes
2. **Check service health**: All three services (database, Redis, Cal.com) must be healthy
3. **Restart the app**: Sometimes a simple restart resolves initial startup issues
4. **Check logs**: View container logs for specific error messages
