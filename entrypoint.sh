#!/bin/bash
set -e

HOST_UID=${HOST_UID:-1000}
HOST_GID=${HOST_GID:-1000}

# Update claude group GID if needed
if [ "$(getent group claude | cut -d: -f3)" != "$HOST_GID" ]; then
    EXISTING_GROUP=$(getent group "$HOST_GID" | cut -d: -f1)
    if [ -n "$EXISTING_GROUP" ]; then
        groupmod -g 9999 "$EXISTING_GROUP"
    fi
    groupmod -g "$HOST_GID" claude
fi

# Update claude user UID if needed
if [ "$(id -u claude)" != "$HOST_UID" ]; then
    EXISTING_USER=$(getent passwd "$HOST_UID" | cut -d: -f1)
    if [ -n "$EXISTING_USER" ] && [ "$EXISTING_USER" != "claude" ]; then
        usermod -u 9999 "$EXISTING_USER"
    fi
    usermod -u "$HOST_UID" claude
fi

# Ensure home dir and workspace root are owned by claude
chown claude:claude /home/claude
chown claude:claude /workspace

exec su-exec claude "$@"
