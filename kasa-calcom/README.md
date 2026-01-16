# Cal.com

Cal.com is the open-source scheduling infrastructure that gives you full control over your calendar and booking workflows. A privacy-focused alternative to Calendly with enterprise-grade features.

## Features

- Customizable booking pages with your branding
- Multiple calendar integrations (Google, Outlook, Apple)
- Team scheduling with round-robin and collective availability
- Automated reminders and notifications
- Video conferencing integrations (Zoom, Google Meet, etc.)
- Payment collection for paid appointments
- Workflow automation and webhooks
- Self-hosted with full data control

## Links

- **Website:** https://cal.com
- **Documentation:** https://cal.com/docs
- **Repository:** https://github.com/calcom/cal.com
- **Support:** https://github.com/calcom/cal.com/discussions

## Access

| Service | URL |
|:--------|:----|
| Web UI | `http://umbrel.local:3002` |

## Configuration

After installation, create your first admin account through the web interface. Configure your calendar integrations and set up your booking page.

### Environment Variables

All secrets are automatically generated using Umbrel's secure seed mechanism:

| Variable | Description |
|:---------|:------------|
| `NEXTAUTH_SECRET` | Session encryption key |
| `CALENDSO_ENCRYPTION_KEY` | Data encryption key |
| `DATABASE_URL` | PostgreSQL connection string |

### Data Storage

| Volume | Path |
|:-------|:-----|
| Database | `${APP_DATA_DIR}/data/db` |
| Redis cache | `${APP_DATA_DIR}/data/redis` |

## Integration Notes

- To integrate with external calendars (Google, Outlook), you'll need to configure OAuth credentials in Cal.com settings
- For video conferencing integration, add your provider API keys in the app settings
- Telemetry is disabled by default for privacy

## Developer

**Cal.com, Inc.** - https://cal.com

---

*Submitted by [Kasa](https://github.com/willrobin/umbrel-community-app-store)*
