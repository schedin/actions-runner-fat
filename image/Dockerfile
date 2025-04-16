FROM ghcr.io/actions/actions-runner:latest

# Temporarily switch to root user for package installation
USER root

# Set environment variable to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install various tools and packages based on VM requirements
RUN apt-get update -y && \
    apt-get install -y \
    # Basic utilities
    curl wget git git-lfs git-ftp jq unzip zip tar gzip bzip2 gnupg gnupg2 apt-transport-https \
    ca-certificates lsb-release software-properties-common \
    # Build tools
    build-essential make cmake gcc g++ clang autoconf automake \
    # Version control
    git git-lfs mercurial subversion \
    # Development tools
    pkg-config libssl-dev zlib1g-dev libcurl4-openssl-dev libexpat1-dev \
    gettext libz-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev \
    libxslt1-dev libffi-dev libtool unixodbc-dev \
    # Network tools
    curl wget net-tools dnsutils netcat iputils-ping iproute2 \
    # Archive tools
    unzip zip tar gzip bzip2 xz-utils zstd \
    # Database clients
    postgresql-client mysql-client sqlite3 \
    # Image processing
    imagemagick \
    # Text processing
    vim nano less grep sed \
    # System utilities
    sudo sysstat lsof strace ltrace procps \
    # Security tools
    openssh-client sshpass haveged \
    # Container tools
    podman skopeo \
    # Documentation tools
    yamllint \
    # Other utilities
    parallel rsync mediainfo \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    curl -sL https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip -o aws-sam-cli.zip && \
    unzip aws-sam-cli.zip -d sam-installation && \
    ./sam-installation/install && \
    rm -rf sam-installation aws-sam-cli.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Install Kubernetes tools
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update -y && \
    apt-get install -y kubectl && \
    rm -rf /var/lib/apt/lists/* && \
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
    chmod +x minikube && \
    mv minikube /usr/local/bin/ && \
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/ && \
    curl -Lo kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64 && \
    chmod +x kind && \
    mv kind /usr/local/bin/

# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add - && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update -y && \
    apt-get install -y helm && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update -y && \
    apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/microsoft-debian-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/microsoft.list && \
    apt-get update -y && \
    apt-get install -y powershell && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js and npm tools
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update -y && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g npm yarn n newman vercel netlify-cli

# Install Python tools
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir pipx && \
    pipx ensurepath

# Install Ruby and related tools
RUN apt-get update -y && \
    apt-get install -y ruby-full && \
    rm -rf /var/lib/apt/lists/*

# Install Java and build tools
RUN apt-get update -y && \
    apt-get install -y openjdk-17-jdk maven gradle && \
    rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . $HOME/.cargo/env

# Install .NET SDK
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/microsoft-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/microsoft.list && \
    apt-get update -y && \
    apt-get install -y dotnet-sdk-8.0 && \
    rm -rf /var/lib/apt/lists/*

# Install PHP
RUN apt-get update -y && \
    apt-get install -y php php-cli php-curl php-mbstring php-xml php-zip && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install additional tools
RUN apt-get update -y && \
    apt-get install -y \
    ansible \
    apt-fast \
    bicep \
    packer \
    r-base \
    ninja-build && \
    rm -rf /var/lib/apt/lists/*

# Reset environment variable
ENV DEBIAN_FRONTEND=

# Switch back to runner user
USER runner