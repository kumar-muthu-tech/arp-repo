# AeroPlanetaAI Blog

Astro + MDX + Tailwind + TypeScript site with static production output.

## Local development

```bash
npm install
npm run dev
```

Open `http://localhost:4321`.

## Docker

Build the static site first, then create and run the small production image:

```bash
npm run build
docker build -t ap-site:latest .
docker run --rm -p 8080:80 ap-site:latest
```

Open `http://localhost:8080`.

The image copies the generated `dist/` directory into `nginx:alpine`. Node and npm are not included in the runtime image.

## Deploy with Docker Compose

On a Linux server with Docker Compose installed:

```bash
git clone <repository-url> ap-site
cd ap-site
npm ci
npm run build
docker compose up -d --build
docker compose ps
docker compose logs --tail=100
```

## GitHub Actions deployment

The `Build and deploy` workflow runs on pushes to `master`. It builds the Astro site, publishes `ghcr.io/<owner>/<repository>:latest`, and deploys it to the server over SSH.

On the Ubuntu server, install Podman and the Compose provider, clone the repository once, and set `IMAGE` when starting Compose:

```bash
sudo apt update
sudo apt install -y podman podman-compose git
sudo mkdir -p /opt/ap-site
sudo git clone <repository-url> /opt/ap-site
cd /opt/ap-site
export IMAGE=ghcr.io/<owner>/<repository>:latest
podman compose up -d
```

Add these GitHub repository secrets before running the workflow: `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`, `DEPLOY_PATH`, `GHCR_USERNAME`, and `GHCR_READ_TOKEN`. The GHCR token needs permission to read packages. `DEPLOY_PORT` is optional and defaults to `22`.

The container listens on port `8080`, leaving public ports 80 and 443 available for a reverse proxy.

For an existing Nginx reverse proxy, proxy `aeroplanetaai.com` to `http://127.0.0.1:8080` and configure a Let's Encrypt certificate. Caddy can provide the same proxy and HTTPS setup with a single site entry:

```text
aeroplanetaai.com {
	reverse_proxy 127.0.0.1:8080
}
```

After updates:

```bash
git pull
npm ci
npm run build
docker compose up -d --build
docker image prune -f
```

Useful checks:

```bash
docker compose ps
docker compose logs --tail=100 ap-site

curl -I http://127.0.0.1:8080
```

The `.dockerignore` keeps `node_modules`, `dist`, `.astro`, Git data, logs, and editor files out of the Docker build context.
