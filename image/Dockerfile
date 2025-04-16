FROM ghcr.io/actions/actions-runner:latest

# The base image will be using this user
ARG BASE_USER runner

# Swtich to root to install packages
USER root

# Set non-interactive mode for apt-get to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

###
# This section is AI generated based on container-image-requirements.md
###

# Install basic utilities and common dependencies
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    # Core utilities
    curl wget git unzip zip tar gzip bzip2 xz-utils p7zip-full p7zip-rar \
    gnupg2 jq \
    # Build tools
    build-essential cmake ninja-build autoconf automake pkg-config make \
    gcc g++ clang llvm \
    # Various libraries and dependencies
    apt-transport-https ca-certificates software-properties-common \
    libssl-dev libcurl4-openssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev \
    libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev \
    # Network tools
    iputils-ping net-tools dnsutils netcat telnet rsync openssh-client sshpass \
    # Text processing
    gettext sed grep gawk \
    # Source control
    subversion mercurial \
    # Archive/compression tools
    zstd \
    # Shell tools
    parallel shellcheck \
    # System tools
    sudo lsb-release locales \
    # Development tools
    sqlite3 libsqlite3-dev \
    # Language support
    python3 python3-dev python3-pip python3-venv \
    python-is-python3 \
    # Database tools
    postgresql-client \
    # And installing more tools
    vim nano \
    # XML/YAML processing
    libxml2-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -y && apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -y && apt-get install -y --no-install-recommends yarn && \
    rm -rf /var/lib/apt/lists/*

# Install podman, skopeo and podman-docker
RUN source /etc/os-release && \
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | \
    tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
    curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | \
    apt-key add - && \
    apt-get update -y && \
    apt-get install -y podman skopeo podman-docker && \
    rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh

# Install OpenJDK and Java development tools
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openjdk-17-jdk maven gradle ant && \
    rm -rf /var/lib/apt/lists/*

# Install GO
RUN curl -fsSL https://go.dev/dl/go1.22.2.linux-amd64.tar.gz -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz && \
    echo "export PATH=\$PATH:/usr/local/go/bin" > /etc/profile.d/go.sh

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo 'source $HOME/.cargo/env' >> /root/.bashrc

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

# Install Ruby
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ruby ruby-dev && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update -y && apt-get install -y --no-install-recommends gh && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update -y && apt-get install -y --no-install-recommends terraform && \
    rm -rf /var/lib/apt/lists/*

# Install .NET SDK
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends dotnet-sdk-6.0 && \
    rm -rf /var/lib/apt/lists/*

###
# End of AI generated section
###

# Reset DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=

# Switch back to base image user
USER ${BASE_USER}