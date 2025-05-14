# Some files will be copied from the actions-runner image.
FROM ghcr.io/actions/actions-runner:latest AS baseimage

FROM docker.io/library/ubuntu:24.04

# The user that should execute the container
ARG BASE_USER=runner

# Switch to root to install packages
USER root

# Set non-interactive mode for apt-get to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Packages listed under https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md#installed-apt-packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    ansible \
    acl \
    aria2 \
    autoconf \
    automake \
    binutils \
    bison \
    brotli \
    bzip2 \
    coreutils \
    curl \
    dbus \
    dnsutils \
    dpkg \
    dpkg-dev \
    fakeroot \
    file \
    findutils \
    flex \
    fonts-noto-color-emoji \
    ftp \
    g++ \
    gcc \
    gnupg2 \
    haveged \
    iproute2 \
    iputils-ping \
    jq \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libyaml-dev \
    locales \
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
    pollinate \
    python-is-python3 \
    rpm \
    rsync \
    shellcheck \
    sphinxsearch \
    sqlite3 \
    ssh \
    sshpass \
    sudo \
    swig \
    systemd-coredump \
    tar \
    telnet \
    texinfo \
    time \
    tk \
    tree \
    tzdata \
    unzip \
    upx \
    wget \
    xvfb \
    xz-utils \
    zip \
    zsync \
    && \
    rm -rf /var/lib/apt/lists/*

# Install more packages not included the VM image apt packages list above
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git \
    && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update -y && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Helm, https://github.com/actions/runner-images/blob/main/images/ubuntu/scripts/build/install-kubernetes-tools.sh
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install kubectl, https://github.com/actions/runner-images/blob/main/images/ubuntu/scripts/build/install-kubernetes-tools.sh
RUN mkdir -p /etc/apt/keyrings && \
    kubectl_minor_version=$(curl -fsSL "https://dl.k8s.io/release/stable.txt" | cut -d'.' -f1,2) && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/$kubectl_minor_version/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$kubectl_minor_version/deb/ /" > /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update -y && \
    apt-get install -y kubectl && \
    rm -f /etc/apt/sources.list.d/kubernetes.list && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

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

# See https://raw.githubusercontent.com/containers/image_build/refs/heads/main/podman/containers.conf
COPY etc_containers_containers.conf /etc/containers/containers.conf
# See https://raw.githubusercontent.com/containers/image_build/refs/heads/main/podman/podman-containers.conf
COPY user_.config_containers_containers.conf /home/${BASE_USER}/.config/containers/containers.conf
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
# Setting CAP_SYS_ADMIN on skopeo binary allows it to access the podman image
# storage, while running in Kubernetes (Ubuntu and CRI-O as container runtime).
# The downside of this is if you run this container image outside kubernetes,
# with podman, you need to run it with --privileged, instead of just
# --device /dev/fuse to use skopeo. See the entrypoint script with a workaround
# for that.
RUN setcap cap_sys_admin+ep /usr/bin/skopeo

ENV _CONTAINERS_USERNS_CONFIGURED=""

###
# End of Podman installation section
###

USER ${BASE_USER}
WORKDIR /home/${BASE_USER}
