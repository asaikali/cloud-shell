# Use Ubuntu 22.04 (Jammy) as the base image
FROM ubuntu:22.04

# Update system and install common utilities
RUN apt-get update -q && \
    apt-get install -yq curl apt-transport-https ca-certificates gnupg unzip git jq sudo lsb-release \
    python3 python3-pip && \
    update-ca-certificates

# Install direnv
RUN apt-get install -yq direnv && \
    echo 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update -q && \
    apt-get install -yq google-cloud-sdk

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg && \
    . /etc/lsb-release && \
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/ ${DISTRIB_CODENAME} main" > \
    /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update -q && \
    apt-get install -yq azure-cli

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm awscliv2.zip

# Install Carvel
RUN curl -L https://carvel.dev/install.sh | bash

# Install kubectl and alias it to k
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    echo 'alias k="kubectl"' >> /etc/bash.bashrc

# PivNet CLI version
ARG PIVNET_VERSION=3.0.0
# Install PivNet CLI using the specified version
RUN curl -LO https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} && \
    chmod +x pivnet-linux-amd64-${PIVNET_VERSION} && \
    mv pivnet-linux-amd64-${PIVNET_VERSION} /usr/local/bin/pivnet

# Teller version
ARG TELLER_VERSION=1.5.6
# Install Teller Secrets Manager from a specific GitHub release
RUN curl -L https://github.com/tellerops/teller/releases/download/v${TELLER_VERSION}/teller_${TELLER_VERSION}_Linux_x86_64.tar.gz -o teller-linux-amd64.tar.gz && \
    tar -xzvf teller-linux-amd64.tar.gz && \
    mv teller /usr/local/bin/teller && \
    rm teller-linux-amd64.tar.gz

# CUE version
ARG CUE_VERSION=0.6.0 
# Install CUE language
RUN curl -L https://github.com/cue-lang/cue/releases/download/v${CUE_VERSION}/cue_v${CUE_VERSION}_linux_amd64.tar.gz -o cue.tar.gz && \
    tar -xzvf cue.tar.gz && \
    mv cue_${CUE_VERSION}_linux_amd64/cue /usr/local/bin/cue && \
    rm cue.tar.gz

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
