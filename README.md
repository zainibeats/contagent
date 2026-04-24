# contagent

A lightweight, provider-agnostic Docker environment for running AI coding agents (Claude Code, Codex, Gemini CLI, etc.) inside a Node.js 24 Alpine container.

## Overview

**What it does:**
- Creates a minimal Alpine Linux container with Node.js 24
- Installs essential dev tools: Git, Python 3, Docker CLI, curl, ripgrep
- Automatically matches the container user's UID/GID to your host user so bind-mounted files have correct ownership
- Mounts your local project directory for seamless file access
- Provides an interactive shell session

## Prerequisites

- **Docker & Docker Compose**: [Install Docker Desktop](https://docs.docker.com/get-docker/) or Docker Engine
- **AI Provider Account**: Access to your preferred CLI tool (Claude Code, Codex, etc.)

## Quick Start

### 1. Clone

```bash
git clone https://github.com/zainibeats/contagent
cd contagent
```

### 2. Configure

Copy `.env.example` to `.env` and set your workspace path:

```bash
cp .env.example .env
```

Edit `.env`:
```
PATH_TO_WORKSPACE=/home/user/my-project
```

### 3. Build and Run

```bash
## Build the Docker image
docker compose build

## Start an interactive session
docker compose run contagent
```

### 4. Use your agent

```bash
## Default: Claude Code
claude

## Or whichever CLI you installed
codex
gemini
```

## Configuration

### Switching AI Providers

Edit `Dockerfile` to install your preferred tool, then rebuild:

```dockerfile
## Install your preferred AI CLI tool (rebuild after changing):
RUN npm install -g @anthropic-ai/claude-code
## RUN npm install -g @openai/codex
## RUN npm install -g @google/gemini-cli
```

```bash
docker compose build
```

### Pre-built Images (Docker Hub)

Pull a pre-built image instead of building from source by uncommenting the `image:` line in `docker-compose.yml`:

```yaml
services:
  contagent:
    image: skimming124/contagent:claude-4.7   ## Claude Code 4.7
    # image: skimming124/contagent:codex-5.5  ## Codex 5.5
```

| Tag | Tool |
|-----|------|
| `claude-4.7` | Claude Code 4.7 |
| `codex-5.5` | OpenAI Codex 5.5 |

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PATH_TO_WORKSPACE` | Host path to mount as `/workspace` | *(required)* |
| `HOST_UID` | UID for the container user | `1000` |
| `HOST_GID` | GID for the container user | `1000` |
| `AGENT_USER` | Container username | `agent` |

To override UID/GID or username at runtime:

```bash
UID=1001 GID=1001 AGENT_USER=myuser docker compose run contagent
```

### Project Structure

```
contagent/
├── Dockerfile          # Container image definition
├── docker-compose.yml  # Service configuration
├── entrypoint.sh       # Runtime UID/GID matching & user switching
├── .env.example        # Environment variable template
└── README.md
```

## Usage

### Basic Workflow

```bash
## 1. Build (one time)
docker compose build

## 2. Start container
docker compose run contagent

## 3. Run your agent
claude

## 4. Exit
exit
```

### Container Management

```bash
## View running containers
docker ps

## Stop container
docker stop contagent

## Remove container
docker rm contagent

## Remove image
docker rmi skimming124/contagent
```
