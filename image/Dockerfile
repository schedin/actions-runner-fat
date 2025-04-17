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

# Install essential packages and dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    # Basic tools
    apt-utils curl wget ca-certificates gnupg2 lsb-release \
    # Version control
    git git-lfs mercurial \
    # Build tools
    build-essential cmake make autoconf automake libtool pkg-config \
    # Compression tools
    bzip2 gzip p7zip-full p7zip-rar unzip xz-utils zstd \
    # Text processing
    jq xmlstarlet \
    # Network tools
    curl iputils-ping netcat net-tools openssh-client rsync ssh sshpass wget \
    # File tools
    file tree \
    # Shell tools
    bash-completion shellcheck \
    # Development libraries
    libssl-dev libyaml-dev libsqlite3-dev \
    # Database tools
    sqlite3 \
    # Java Development
    openjdk-17-jdk openjdk-17-jre \
    # Python
    python3 python3-pip python3-dev python-is-python3 \
    # Ruby
    ruby ruby-dev \
    # Perl
    perl \
    # Node.js and npm (latest LTS)
    nodejs npm \
    # Additional development tools
    ninja-build \
    # Utilities
    parallel pigz patchelf upx tzdata locales \
    # SCM & CI/CD tools
    subversion \
    # Build system
    ninja-build \
    # Misc
    aria2 bison flex lsof mediainfo RPM && \
    rm -rf /var/lib/apt/lists/*

# Set up locales
RUN locale-gen en_US.UTF-8

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh && \
    helm version

# Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    kubectl version --client

# Install yq (yaml processor)
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y gh && \
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
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-latest-linux-x86_64.tar.gz && \
    tar -xf google-cloud-cli-latest-linux-x86_64.tar.gz && \
    ./google-cloud-sdk/install.sh --quiet && \
    rm -rf google-cloud-cli-latest-linux-x86_64.tar.gz

# Install additional Python tools
RUN pip3 install --no-cache-dir pipx && \
    pipx install yamllint

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

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