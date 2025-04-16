FROM ghcr.io/actions/actions-runner:latest

LABEL org.opencontainers.image.source="https://github.com/schedin/actions-runner-fat"
LABEL org.opencontainers.image.description="GitHub Actions runner with additional tools"

# Update and install common tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    wget \
    zip \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*
