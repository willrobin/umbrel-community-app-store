FROM python:3.11-slim

LABEL org.opencontainers.image.source="https://github.com/willrobin/umbrel-community-app-store"
LABEL org.opencontainers.image.description="Compose Patcher UI für UmbrelOS"

WORKDIR /app

# Abhängigkeiten installieren
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Anwendung kopieren
COPY server.py .
COPY templates/ templates/
COPY static/ static/

# Port freigeben
EXPOSE 5000

# Nicht-Root User verwenden
RUN adduser --disabled-password --gecos "" --uid 1000 appuser
USER appuser

# gunicorn für Produktion
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--timeout", "120", "server:app"]
