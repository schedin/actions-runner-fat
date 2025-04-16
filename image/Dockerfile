FROM ghcr.io/actions/actions-runner:latest

# The base image will be using this user
ARG BASE_USER=runner

# Swtich to root to install packages
USER root

# Set non-interactive mode for apt-get to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

###
# This section is AI generated based on container-image-requirements.md
###

# Install basic tools and build essentials
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    # Basic tools
    curl wget git unzip zip tar gzip bzip2 gnupg lsb-release \
    apt-transport-https ca-certificates software-properties-common \
    # Build essentials and development tools
    build-essential gcc g++ make cmake autoconf automake \
    # Python tools
    python3 python3-pip python3-dev python-is-python3 \
    # Text processing and utilities
    jq gettext \
    # Network tools
    curl wget iputils-ping telnet netcat net-tools \
    # Archive tools
    zip unzip p7zip-full p7zip-rar \
    # Version control systems
    git git-lfs mercurial subversion \
    # SSH and security tools
    openssh-client sshpass gnupg2 pass \
    # Compression tools
    xz-utils lz4 pigz zstd \
    # File manipulation tools
    file findutils patchelf \
    # Process tools
    time parallel procps \
    # Text editors
    vim nano \
    # Utilities
    sudo coreutils moreutils \
    # XML/YAML/JSON tools
    xmlstarlet \
    # Database clients
    sqlite3 \
    # Image processing
    imagemagick \
    # Development libraries
    libssl-dev libcurl4-openssl-dev libxml2-dev \
    libyaml-dev libffi-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev liblzma-dev \
    # Java
    openjdk-17-jdk openjdk-17-jre \
    # Ruby dependencies
    libyaml-dev libssl-dev libgdbm-dev libreadline-dev libffi-dev \
    # Node.js prerequisites
    xvfb libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 \
    libnss3 libxss1 libasound2 libxtst6 xauth \
    # C/C++ development tools
    clang clang-format clang-tidy \
    # Additional development tools
    pkg-config gfortran valgrind \
    # Shell tools
    shellcheck \
    # Ansible dependencies
    swig \
    # Performance tools
    sysstat \
    # Additional utilities
    rsync ftp mediainfo haveged fakeroot \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh

# Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update -y \
    && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update -y \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install tools via npm
RUN npm install -g yarn@latest typescript@latest grunt@latest

# Install Rust and Cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

###
# End of AI generated section
###

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    podman skopeo podman-docker \
    && rm -rf /var/lib/apt/lists/*

# Reset DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=

# Switch back to base image user
USER ${BASE_USER}