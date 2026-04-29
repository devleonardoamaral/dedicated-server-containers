# Minecraft Neoforge Dedicated Server

Containerized setup for running a Minecraft Neoforge Dedicated Server using Podman or Docker, with persistent worlds and configurable settings.

# Starting

```bash
podman-compose up -d --build
```

# Stopping Safely

```bash
podman-compose down
```

# Updating

Rebuild images after game updates or config changes. Saves are preserved in the volume:

```bash
podman-compose up -d --build --no-cache
```

# Logs

```bash
# All services
podman-compose logs

# Follow in real time
podman-compose logs -f

# Last 50 lines only
podman-compose logs --tail 50
```
