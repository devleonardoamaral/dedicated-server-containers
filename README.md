# Terraria Dedicated Server

Containerized setup for running a **Terraria Dedicated Server** using Podman or Docker, with persistent worlds and configurable settings.

## Features

* Automatic world creation
* Fully configurable server settings
* Persistent volume for worlds and backups

---

## Server Setup

To run the server, you need to configure the persistent data volume and server parameters.

### Configuration

Set server parameters via build arguments in `compose.yml`:

```bash
nano compose.yml
```

Default parameters:

| Argument         | Default                            |
| ---------------- | ---------------------------------- |
| VERSION          | 1456                               |
| LANG             | en-US                              |
| WORLD_NAME       | world1                             |
| WORLD_SIZE       | 2                                  |
| WORLD_SEED       | AwesomeSeed                        |
| WORLD_DIFFICULTY | 2                                  |
| MAX_PLAYERS      | 16                                 |
| PASSWORD         | password                           |
| MOTD             | Please don’t cut the purple trees! |
| SECURE           | 0                                  |
| UPNP             | 0                                  |
| NPCSTREAM        | 60                                 |
| PRIORITY         | 1                                  |
| JOURNEY_*        | 2 (everyone)                       |

### Ports

Internally, the container exposes ports `7777/tcp` and `7777/udp`. To allow players to connect, map the port to the host and forward it through your network:

```bash
nano compose.yml
```

```yml
ports:
  # "Host:Container/protocol"
  - "7777:7777/tcp"
  - "7777:7777/udp"
```

### Starting

```bash
podman-compose up -d --build
```

### Accessing Console

```bash
podman attach dedicated-server-containers_server_1
```

* Type commands like `save` or `exit`.
* Detach without stopping the container: `Ctrl+P` then `Ctrl+Q`.

### Stopping Safely

1. Attach to the console (see above)
2. Type:

```text
exit
```

> ⚠️ **WARNING:** Avoid using `SIGKILL` or `podman stop` without exiting first, as the world may not save properly.

### Logs

To view the server logs, use:

```bash
# All services
podman-compose logs

# Follow in real time
podman-compose logs -f

# Last 50 lines only
podman-compose logs --tail 50
```

### Persistent Volume

The persistent volume containing the saves is stored in specific paths depending on the containerization software used.

- Podman (rootless): `$HOME/.local/share/containers/storage/volumes/terraria-data/_data/`
- Podman (root): `/var/lib/containers/storage/volumes/terraria-data/_data/`
- Docker: `/var/lib/docker/volumes/terraria-data/_data/`
