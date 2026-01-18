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
| `NEXTAUTH_URL` | Public URL (uses `${DEVICE_DOMAIN_NAME}:3002`) |
| `NEXTAUTH_SECRET` | Authentication secret (uses `${APP_SEED}`) |
| `CALENDSO_ENCRYPTION_KEY` | Encryption key (uses `${APP_SEED}`) |

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
