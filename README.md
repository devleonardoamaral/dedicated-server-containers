# Don’t Starve Together Dedicated Server

Containerized setup for running a Don't Starve Together Dedicated Server using Podman or Docker, with persistent worlds and configurable settings.

---

## Initial setup

1. Go to [Klei's server page](https://accounts.klei.com/account/game/servers?game=DontStarveTogether) and log into your account.
2. Create a new server — it can be named anything, like MyDediServer.
3. Download the generated zip file (e.g., `MyDediServer.zip`).
4. Extract it and copy all files from inside the zip into `./image/servercfg/`, overwriting the existing defaults:

```bash
# Example: if you extracted to ~/Downloads/MyDediServer/
cp ~/Downloads/MyDediServer/* ./image/servercfg/
```
> The default config files are already there — replace them with your downloaded versions. Do not overwrite cluster_token.txt; your token will be injected via .env at runtime.

5. Open the downloaded `cluster_token.txt` and copy the token string inside.
6. In your repository folder, copy `.env.example` to `.env`:

```bash
cp .env.example .env
```

7. Open `.env` and paste the token as the value for `KLEI_TOKEN`:

```txt
KLEI_TOKEN=your-copied-token-here
```
> The token will be injected into the game's config at runtime.

## Starting

```sh
podman-compose up -d --build
```

The first build downloads and installs the game (~2GB), so it may take several minutes.

## Stopping Safely

Don't Starve Together **does not respond to stop signals**. Graceful shutdown must be done manually through each shard's console to prevent world corruption.

Stop Caves first, then Master:

```bash
podman attach dst-caves
```

Type in the console:

```txt
c_shutdown()
```

Wait for the process to exit, then detach with `Ctrl+P`, `Ctrl+Q`.

```bash
podman attach dst-master
```

Type in the console:

```txt
c_shutdown()
```

Wait for the process to exit, then detach with `Ctrl+P`, `Ctrl+Q`.

## Updating

Rebuild images after game updates or config changes. Saves are preserved in the volume:

```bash
podman-compose up -d --build --no-cache
```

## Logs

To view the server logs, use:

```bash
# All services
podman-compose logs

# Follow in real time
podman-compose logs -f

# Last 50 lines only
podman-compose logs --tail 50

# Specific container
podman logs -f dst-master
```

## Where save data is stored

World saves and config persist in a Docker/Podman volume. You can access the files directly at:

| Setup | Path |
|-------|------|
| Podman (rootless) | `$HOME/.local/share/containers/storage/volumes/dst-data/_data/` |
| Podman (root) | `/var/lib/containers/storage/volumes/dst-data/_data/` |
| Docker | `/var/lib/docker/volumes/dst-data/_data/` |

## Notes

* Port forwarding isn't required for the server to be visible.
