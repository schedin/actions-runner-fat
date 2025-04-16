# This Dockerfile was AI generated based on container-image-requirements.md

# Use the latest official GitHub Actions runner image as the base
FROM ghcr.io/actions/actions-runner:latest

# Switch to root user for package installation
USER root

# Set environment variable to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install all necessary tools and packages based on the GitHub runner images VM document
RUN apt-get update -y && \
    apt-get install -y \
    # Basic utilities
    apt-utils apt-transport-https ca-certificates software-properties-common \
    gnupg lsb-release curl wget unzip zip tar gzip bzip2 xz-utils \
    git git-lfs git-ftp mercurial subversion \
    jq \
    # Build tools
    build-essential make cmake autoconf automake libtool pkg-config \
    # Languages and runtimes
    python3 python3-pip python3-venv \
    ruby ruby-dev \
    nodejs npm \
    # Compilers and related tools
    gcc g++ gfortran \
    clang clang-format clang-tidy \
    # System utilities
    coreutils findutils grep sed gawk \
    # Network tools
    iputils-ping iproute2 net-tools netcat dnsutils curl wget \
    # Archive tools
    zip unzip tar gzip bzip2 xz-utils \
    # Security tools
    openssh-client sshpass gnupg2 \
    # Development libraries
    zlib1g-dev libssl-dev libcurl4-openssl-dev libxml2-dev \
    libyaml-dev libunwind8 \
    # Text processing
    jq gettext \
    # Image processing
    imagemagick \
    # Python dependencies
    python3-setuptools python3-dev \
    # Version control
    git git-lfs \
    # CI/CD tools
    rsync \
    # Other utilities
    locales sudo \
    # Podman, Skopeo, and docker emulation layer
    podman skopeo podman-docker \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/ && \
    kubectl version --client

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh

# Install Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/

# Install yq
RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq

# Install cloud CLIs
# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /var/lib/apt/lists/*

# Google Cloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update -y && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update -y && \
    apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN pip3 install ansible

# Install ORAS CLI
RUN curl -LO https://github.com/oras-project/oras/releases/latest/download/oras_$(curl -s https://api.github.com/repos/oras-project/oras/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')_linux_amd64.tar.gz && \
    mkdir -p oras-install/ && \
    tar -zxf oras_*_linux_amd64.tar.gz -C oras-install/ && \
    mv oras-install/oras /usr/local/bin/ && \
    rm -rf oras_*_linux_amd64.tar.gz oras-install/

# Unset the DEBIAN_FRONTEND environment variable
ENV DEBIAN_FRONTEND=

# Switch back to the runner user
USER runner