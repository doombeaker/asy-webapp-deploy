# Asymptote Web Application Deployment

Docker-based deployment of [asymptoteWebApplication](https://github.com/vectorgraphics/asymptoteWebApplication) — a web IDE for the Asymptote vector graphics language.

## Quick Start

### 1. Clone the application source

```shell
cd asy-backend \
    && git clone https://github.com/vectorgraphics/asymptoteWebApplication.git \
    && cd ..
```

### 2. Build and run

```shell
docker compose up -d --build
```

The app will be available at `http://localhost:9527`.

## Configuration

- **Port**: Change the host port mapping in `docker-compose.yml`:
  ```yaml
  ports:
    - "0.0.0.0:<HOST_PORT>:80"
  ```
- **Extra Asymptote modules**: Place `.asy` files in `asy-backend/asy_extra_modules/` — they are mounted read-only into the container.
