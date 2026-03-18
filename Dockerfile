FROM node:24-alpine

RUN apk add --no-cache \
    bash \
    git \
    curl \
    python3 \
    docker-cli \
    su-exec \
    shadow \
    ripgrep

ENV SHELL=/bin/bash \
    NODE_ENV=development \
    USE_BUILTIN_RIPGREP=0

RUN addgroup -g 1000 claude && \
    adduser -D -u 1000 -G claude -h /home/claude claude

WORKDIR /workspace

RUN npm install -g @anthropic-ai/claude-code

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
