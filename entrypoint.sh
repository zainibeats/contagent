#!/bin/bash
## Fixes ownership of the mounted workspace at runtime
chown claude:claude /workspace

## Drop from root to the claude user, then exec the CMD
exec su-exec claude "$@"
