# Don’t Starve Together Dedicated Server

Containerized setup for running a Don't Starve Together Dedicated Server using Podman or Docker, with persistent worlds and configurable settings.

---

## Initial setup

1. Go to [Klei's server page](https://accounts.klei.com/account/game/servers?game=DontStarveTogether) and log into your account.
2. Create a new server — the name doesn't matter, e.g. `MyDediServer`.
3. Download the generated zip file and extract it.
4. Copy all files from the extracted zip into `./image/servercfg/`, overwriting the existing defaults:

   ```bash
   cp ~/Downloads/MyDediServer/* ./image/servercfg/
   ```

   > The default config files are already there, replace them with your downloaded versions.

## Starting

```sh
podman-compose up -d --build
```

The first build downloads and installs the game (~4GB), so it may take several minutes.

## Stopping Safely

Don't Starve Together **does not respond to stop signals**. Graceful shutdown must be done manually through each shard's console to prevent world corruption.

1. Stop Caves first, then Master:

  ```bash
  podman attach dst-caves
  ```

2. Type in the console:

  ```txt
  c_shutdown()
  ```

3. Press `ENTER` and wait for the process to exit.

  ```bash
  podman attach dst-master
  ```

4. Type in the console:

  ```txt
  c_shutdown()
  ```

5. Press `ENTER` and wait for the process to exit.
6. Remove the containers:

  ```bash
  podman-compose down
  ```

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
