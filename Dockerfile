# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update system and install common dependencies, and update CA certificates
RUN apt-get update -q \
    && apt-get install -yq curl apt-transport-https ca-certificates gnupg unzip \
    && update-ca-certificates

# Install direnv
RUN apt-get install -yq direnv \
    && echo 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc

# Install Carvel
RUN curl -L https://carvel.dev/install.sh | bash

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/kubectl

# Argument for PivNet CLI version
ARG PIVNET_VERSION=3.0.0

# Install PivNet CLI using the specified version
RUN curl -LO https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} \
    && chmod +x pivnet-linux-amd64-${PIVNET_VERSION} \
    && mv pivnet-linux-amd64-${PIVNET_VERSION} /usr/local/bin/pivnet

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update -q \
    && apt-get install -yq google-cloud-sdk

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*
