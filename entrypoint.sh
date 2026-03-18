#!/bin/bash
set -e

HOST_UID=${HOST_UID:-1000}
HOST_GID=${HOST_GID:-1000}

# Update claude group GID if needed
if [ "$(getent group claude | cut -d: -f3)" != "$HOST_GID" ]; then
    groupmod -g "$HOST_GID" claude
fi

# Update claude user UID if needed
if [ "$(id -u claude)" != "$HOST_UID" ]; then
    usermod -u "$HOST_UID" claude
fi

# Ensure home dir and workspace root are owned by claude
chown claude:claude /home/claude
chown claude:claude /workspace

exec su-exec claude "$@"
