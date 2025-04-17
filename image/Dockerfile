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

# Install main packages
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ansible \
    apt-transport-https \
    apt-utils \
    aria2 \
    autoconf \
    automake \
    binutils \
    bison \
    brotli \
    build-essential \
    bzip2 \
    ca-certificates \
    clang \
    cmake \
    coreutils \
    curl \
    dirmngr \
    dnsutils \
    dpkg-dev \
    fakeroot \
    file \
    flex \
    fonts-noto-color-emoji \
    ftp \
    g++ \
    gcc \
    gfortran \
    git \
    git-ftp \
    git-lfs \
    gnupg2 \
    haveged \
    iproute2 \
    iputils-ping \
    jq \
    libcurl4-openssl-dev \
    libgbm-dev \
    libgconf-2-4 \
    libgsl-dev \
    libicu-dev \
    liblttng-ust-dev \
    libssl-dev \
    libtool \
    libunwind8 \
    libxkbfile-dev \
    libxml2-dev \
    libyaml-dev \
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
    p7zip-rar \
    parallel \
    patchelf \
    pigz \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    python-is-python3 \
    rpm \
    rsync \
    shellcheck \
    software-properties-common \
    sqlite3 \
    ssh \
    sshpass \
    swig \
    tar \
    telnet \
    texinfo \
    time \
    tzdata \
    unzip \
    upx \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
    zstd \
    && rm -rf /var/lib/apt/lists/*

# Install OpenJDK
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update -y && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update -y && apt-get install -y google-cloud-cli \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash \
    && rm -rf /var/lib/apt/lists/*

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq

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