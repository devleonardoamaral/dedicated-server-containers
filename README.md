# Minecraft PaperMC

This repository contains images for creating PaperMC containers in different versions of Minecraft and PaperMC.

## Starting server

```bash
podman compose up -d
```

## Stopping server

```bash
podman compsoe down
```

## Updating image

First, change the parameters of `compose.yml` to your desired Minecraft version and PaperMC build. To obtain the Minecraft versions and PaperMC builds, please refer to [this link](https://fill-ui.papermc.io/projects/paper).

```yml
build:
  args:
    MC_VERSION: 26.1.1
    PAPER_BUILD: 29
```

Then, restart the server, forcing the image to rebuild.

```bash
podman compose down
podman compose up -d --build --no-cache
```
