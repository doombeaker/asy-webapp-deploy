# Asymptote Web App

Docker-based deployment of the [Asymptote](https://asymptote.sourceforge.io/) web IDE.

## Quick Start

```shell
./build.sh    # build docker image
./run.sh      # start container
```

The app will be available at `http://localhost:9527`.

## Project Structure

```
asy-app/
  server/          Express backend (compiles & serves Asymptote code)
  ui/              React frontend (CRA)
```

## Manual Build & Run

```shell
# Build image
docker build -t asy-webapp .

# Run container
docker run -d \
    --name asy-webapp \
    --restart always \
    -p 9527:80 \
    -v ./asy_extra_modules:/home/asymptote/.asy:ro \
    asy-webapp
```

## Configuration

- `build.sh` — `USER_UID` (default `1000`)
- `run.sh` — `HOST_PORT` (default `9527`)

Extra Asymptote modules can be placed in `asy_extra_modules/`.
