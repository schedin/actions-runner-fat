FROM ghcr.io/actions/actions-runner:latest

LABEL org.opencontainers.image.source="https://github.com/schedin/actions-runner-fat"
LABEL org.opencontainers.image.description="GitHub Actions runner with additional tools"

# Swtich to root to be able to install packages
USER root

RUN apt-get update && sudo apt-get install -y \
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

# Switch back to base image user
USER runner
