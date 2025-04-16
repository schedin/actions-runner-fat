# This Dockerfile was AI generated based on container-image-requirements.md
FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install packages
USER root

# Install packages
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y \
    # Basic utilities
    apt-utils \
    curl \
    wget \
    git \
    zip \
    unzip \
    tar \
    gzip \
    bzip2 \
    gnupg \
    gnupg2 \
    apt-transport-https \
    software-properties-common \
    ca-certificates \
    lsb-release \
    # Build tools
    build-essential \
    cmake \
    gcc \
    g++ \
    make \
    # Programming languages and runtimes
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python-is-python3 \
    # Version control
    git-lfs \
    git-ftp \
    subversion \
    mercurial \
    # Network tools
    curl \
    wget \
    iputils-ping \
    dnsutils \
    net-tools \
    netcat \
    openssh-client \
    sshpass \
    rsync \
    # Text processing
    jq \
    xmlstarlet \
    xsltproc \
    # Container tools
    podman \
    buildah \
    skopeo \
    podman-docker \
    # Database clients
    postgresql-client \
    mysql-client \
    sqlite3 \
    # Other tools
    sudo \
    fakeroot \
    xz-utils \
    lz4 \
    shellcheck \
    locales \
    tzdata \
    # Development tools
    clang \
    llvm \
    gfortran \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    rm -rf /var/lib/apt/lists/*

# Install OpenJDK
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y openjdk-17-jdk openjdk-17-jre && \
    rm -rf /var/lib/apt/lists/*

# Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Go
RUN wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz && \
    rm go1.22.1.linux-amd64.tar.gz && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

# Install .NET SDK
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y dotnet-sdk-8.0 && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y ansible && \
    rm -rf /var/lib/apt/lists/*

# Install Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar -xzf apache-maven-3.9.9-bin.tar.gz -C /opt && \
    rm apache-maven-3.9.9-bin.tar.gz && \
    ln -s /opt/apache-maven-3.9.9/bin/mvn /usr/local/bin/mvn

# Reset DEBIAN_FRONTEND
ENV DEBIAN_FRONTEND=

# Switch back to runner user
USER runner