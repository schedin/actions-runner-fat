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

# Install base packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ansible \
    apt-utils \
    autoconf \
    automake \
    binutils \
    bison \
    build-essential \
    bzip2 \
    ca-certificates \
    clang \
    cmake \
    coreutils \
    curl \
    dbus \
    dnsutils \
    dpkg \
    dpkg-dev \
    fakeroot \
    file \
    flex \
    fonts-noto-color-emoji \
    ftp \
    g++ \
    gcc \
    gettext \
    git \
    gnupg2 \
    haveged \
    imagemagick \
    iproute2 \
    iputils-ping \
    jq \
    libc6-dev \
    liblttng-ust1 \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libyaml-dev \
    locales \
    lsb-release \
    lz4 \
    m4 \
    make \
    mediainfo \
    mercurial \
    net-tools \
    netcat-openbsd \
    openssh-client \
    p7zip-full \
    parallel \
    patchelf \
    pigz \
    pkg-config \
    python-is-python3 \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    rsync \
    shellcheck \
    sphinxsearch \
    sqlite3 \
    ssh \
    sshpass \
    subversion \
    sudo \
    tar \
    texinfo \
    time \
    tree \
    tzdata \
    unzip \
    upx \
    wget \
    xvfb \
    xz-utils \
    zip \
    zlib1g-dev \
    zstd \
    && rm -rf /var/lib/apt/lists/*

# Install OpenJDK
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    default-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update -y \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update -y \
    && apt-get install -y azure-cli \
    && rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-latest-linux-x86_64.tar.gz \
    && tar -xf google-cloud-cli-latest-linux-x86_64.tar.gz \
    && ./google-cloud-sdk/install.sh --quiet \
    && rm google-cloud-cli-latest-linux-x86_64.tar.gz \
    && ln -s /google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update -y \
    && apt-get install -y gh \
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
RUN setcap cap_sys_admin+ep /usr/bin/skopeo

ENV _CONTAINERS_USERNS_CONFIGURED=""

###
# End of Podman installation section
###

USER ${BASE_USER}
WORKDIR /home/${BASE_USER}