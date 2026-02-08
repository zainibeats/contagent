## 1. Base image: lightweight Node.js 24 on Alpine
FROM node:24-alpine

## 2. Install essential tools
RUN apk add --no-cache \
    bash \
    git \
    curl \
    wget \
    python3 \
    docker-cli \
    su-exec

## 3. Set environment variables
ENV SHELL=/bin/bash \
    NODE_ENV=development \
    TERM=xterm-256color

## 4. Create a non-root user
RUN addgroup -g 1001 claude && \
    adduser -D -u 1001 -G claude claude

## 5. Set working directory
WORKDIR /workspace

## 6. Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

## 7. Copy entrypoint script (runs as root, then drops to claude user)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

## 8. Entrypoint handles permissions and user switching at runtime
ENTRYPOINT ["/entrypoint.sh"]

## 9. Default command: start bash shell
CMD ["/bin/bash"]
