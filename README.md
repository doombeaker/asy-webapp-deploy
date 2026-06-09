# Asymptote Web App

Docker-based deployment of the [Asymptote](https://asymptote.sourceforge.io/) web IDE.

## Quick Start

```shell
./build.sh    # build docker image
./run.sh      # start container
```

The app will be available at `http://localhost:9527`.

## Manual Build & Run

```shell
# Build image
docker build -t asy-webapp .

# Run container
docker run -d \
    --name asy-webapp \
    --restart always \
    -p 9527:80 \
    -e LIBGS=/usr/lib/x86_64-linux-gnu/libgs.so.10 \
    -v ./asy_extra_modules:/home/asymptote/.asy:ro \
    asy-webapp
```

## Configuration

- `build.sh` — `USER_UID` (default `1000`)
- `run.sh` — `HOST_PORT` (default `9527`)

Extra Asymptote modules can be placed in `asy_extra_modules/`.
