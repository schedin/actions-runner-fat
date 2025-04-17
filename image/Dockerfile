# Some files will be copied from the actions-runner image.
FROM ghcr.io/actions/actions-runner:latest as baseimage

FROM docker.io/library/ubuntu:24.04

# The user that should execute the container
ARG BASE_USER=runner

# Switch to root to install packages
USER root

# Set non-interactive mode for apt-get to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

###
# This section is AI generated based on container-image-requirements.md
###

# Install basic packages and dependencies
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    # Basic utils
    apt-utils \
    apt-transport-https \
    bzip2 \
    ca-certificates \
    curl \
    dirmngr \
    file \
    fonts-noto-color-emoji \
    gnupg2 \
    wget \
    unzip \
    zip \
    xz-utils \
    # Version control systems
    git \
    git-lfs \
    git-ftp \
    mercurial \
    subversion \
    # Network tools
    dnsutils \
    iproute2 \
    iputils-ping \
    netcat-openbsd \
    net-tools \
    openssh-client \
    sshpass \
    rsync \
    # Compression
    brotli \
    gzip \
    p7zip-full \
    p7zip-rar \
    parallel \
    pigz \
    zstd \
    # Development
    autoconf \
    automake \
    binutils \
    bison \
    build-essential \
    cmake \
    dpkg-dev \
    fakeroot \
    flex \
    g++ \
    gcc \
    jq \
    libtool \
    lsb-release \
    make \
    ninja-build \
    patchelf \
    pkg-config \
    shellcheck \
    # Python
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    python-is-python3 \
    # Database
    libsqlite3-dev \
    sqlite3 \
    # Ruby 
    ruby \
    ruby-dev \
    # Other tools
    aria2 \
    ftp \
    tree \
    tzdata \
    upx \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update -y \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && rm -rf /var/lib/apt/lists/*

# Install OpenJDK
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    openjdk-17-jre \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN curl -fsSL https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends powershell \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -fsSL https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends helm \
    && rm -rf /var/lib/apt/lists/*

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends azure-cli \
    && rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

###
# End of AI generated section
###

###
# Setting the environment similar to ghcr.io/actions/actions-runner
###
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends adduser sudo lsb-release gpg-agent software-properties-common apt-utils

RUN adduser --disabled-password --gecos "" --uid 1001 ${BASE_USER} \
    && usermod -aG sudo ${BASE_USER} \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

COPY --chown=${BASE_USER}:${BASE_USER} --from=baseimage /home/${BASE_USER} /home/${BASE_USER}/.

###
# Podman installation
###
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    adduser sudo \
    # Make it possible for Podman to run namespaced user id
    uidmap \
    # Used to set file based capabilities for newuidmap/newgidmap to make Podman work
    libcap2-bin \
    # Podman and tools
    podman fuse-overlayfs slirp4netns podman-docker skopeo \
    # New CA certificates to be able to pull images from docker.io etc
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Replace the auto-genereted ID mappings
RUN echo "${BASE_USER}:1002:64534" > /etc/subuid && \
    echo "${BASE_USER}:1002:64534" > /etc/subgid

ARG _REPO_URL="https://raw.githubusercontent.com/containers/image_build/refs/heads/main/podman"
ADD $_REPO_URL/containers.conf /etc/containers/containers.conf
ADD $_REPO_URL/podman-containers.conf /home/${BASE_USER}/.config/containers/containers.conf
COPY etc_containers_storage.conf /etc/containers/storage.conf

RUN mkdir -p /home/${BASE_USER}/.local/share/containers && \
    chown ${BASE_USER}:${BASE_USER} -R /home/${BASE_USER} && \
    chmod 0644 /etc/containers/containers.conf

# Replace setuid bits by proper file capabilities for uidmap binaries.
# See <https://github.com/containers/podman/discussions/19931>.
RUN chmod 0755 /usr/bin/newuidmap /usr/bin/newgidmap && \
    setcap cap_setuid=ep /usr/bin/newuidmap && \
    setcap cap_setgid=ep /usr/bin/newgidmap

# Workaround for that skopeo cannot interact with the podman image storage.
# While running "skopeo inspect containers-storage:alpine" you might get
# "Error during unshare(...): Operation not permitted".
# Setting CAP_SYS_ADMIN on skopeo binary allows it to access the podman image storage.
RUN sudo setcap cap_sys_admin+ep /usr/bin/skopeo

ENV _CONTAINERS_USERNS_CONFIGURED=""

###
# End of Podman installation section
###

USER ${BASE_USER}
WORKDIR /home/${BASE_USER}