# This Dockerfile was AI-generated based on the requirements in container-image-requirements.md

FROM ghcr.io/actions/actions-runner:latest

# Switch to root user for installation
USER root

# Set up environment variables for installation
ENV DEBIAN_FRONTEND=noninteractive

# Install all required packages
RUN apt-get update -y && \
    apt-get install -y \
    # Basic utilities and dependencies
    apt-utils \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    gnupg2 \
    lsb-release \
    software-properties-common \
    wget \
    # Archive and compression tools
    bzip2 \
    gzip \
    p7zip-full \
    p7zip-rar \
    tar \
    unzip \
    xz-utils \
    zip \
    zstd \
    # Development tools
    autoconf \
    automake \
    build-essential \
    cmake \
    gcc \
    g++ \
    clang \
    clang-format \
    clang-tidy \
    gfortran \
    libtool \
    m4 \
    make \
    pkg-config \
    # Version control systems
    git \
    git-ftp \
    git-lfs \
    mercurial \
    subversion \
    # Text processing and utilities
    jq \
    nano \
    sed \
    vim \
    yq \
    # Network tools
    dnsutils \
    iproute2 \
    iputils-ping \
    net-tools \
    netcat \
    openssh-client \
    ssh \
    sshpass \
    telnet \
    wget \
    # Language runtimes and tools
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    perl \
    ruby \
    ruby-dev \
    # Libraries and dependencies
    libcurl4 \
    libgbm-dev \
    libgconf-2-4 \
    libgtk2.0-0 \
    libgtk-3-0 \
    libnotify-dev \
    libnss3 \
    libssl-dev \
    libxss1 \
    libxtst6 \
    libxkbfile-dev \
    libyaml-dev \
    lib32z1 \
    # Container tools
    docker-buildx-plugin \
    docker-compose-plugin \
    # Other utilities
    imagemagick \
    parallel \
    sudo \
    swig \
    time \
    tzdata \
    yamllint \
    && \
    # Clean up
    rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh

# Install kubectl
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update -y && \
    apt-get install -y kubectl && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update -y && \
    apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN pip3 install ansible

# Install Docker Amazon ECR Credential Helper
RUN apt-get update -y && \
    apt-get install -y amazon-ecr-credential-helper && \
    rm -rf /var/lib/apt/lists/*

# Install Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/

# Install additional tools with pip
RUN pip3 install --no-cache-dir \
    yamllint \
    pipx

# Unset DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=

# Switch back to runner user
USER runner