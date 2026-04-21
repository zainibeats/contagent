#!/bin/bash
set -e

HOST_UID=${HOST_UID:-1000}
HOST_GID=${HOST_GID:-1000}
AGENT_USER=${AGENT_USER:-agent}

# Update group GID if needed
if [ "$(getent group $AGENT_USER | cut -d: -f3)" != "$HOST_GID" ]; then
    EXISTING_GROUP=$(getent group "$HOST_GID" | cut -d: -f1)
    if [ -n "$EXISTING_GROUP" ]; then
        groupmod -g 9999 "$EXISTING_GROUP"
    fi
    groupmod -g "$HOST_GID" "$AGENT_USER"
fi

# Update user UID if needed
if [ "$(id -u $AGENT_USER)" != "$HOST_UID" ]; then
    EXISTING_USER=$(getent passwd "$HOST_UID" | cut -d: -f1)
    if [ -n "$EXISTING_USER" ] && [ "$EXISTING_USER" != "$AGENT_USER" ]; then
        usermod -u 9999 "$EXISTING_USER"
    fi
    usermod -u "$HOST_UID" "$AGENT_USER"
fi

# Ensure home dir and workspace are owned by agent user
chown "$AGENT_USER:$AGENT_USER" "/home/$AGENT_USER"
chown "$AGENT_USER:$AGENT_USER" /workspace

exec su-exec "$AGENT_USER" "$@"
