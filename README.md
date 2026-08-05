# Minecraft PaperMC Dedicated Server

Containerized setup for running a Minecraft PaperMC Dedicated Server using Podman, with persistent worlds and configurable settings.

## Starting

Copy the `.env.example` file and rename it to `.env`s:

```bash
cp .env.example .env
```

Then edit the values within this file according to your needs:

```bash
nano .env
```

Start the server using the command below; the first run takes longer because the image is being built:

```bash
podman-compose up -d --build
```

## Stopping Safely

```bash
podman-compose down
```

## Updating

Rebuild the image after modifying the `.env` file. The volume containing the server save is preserved:

```bash
podman-compose up -d --build --no-cache
```

## Logs

```bash
# All services
podman-compose logs

# Follow in real time
podman-compose logs -f

# Last 50 lines only
podman-compose logs --tail 50
```