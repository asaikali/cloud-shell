# Ubuntu codename (22.04 - Jammy)
ARG UBUNTU_CODENAME=jammy

# PivNet CLI version
ARG PIVNET_VERSION=3.0.0

# Specify Teller version as an argument
ARG TELLER_VERSION=1.5.6

# Use specified Ubuntu codename as the base image
FROM ubuntu:${UBUNTU_CODENAME}

# Update system and install common utilities
RUN apt-get update -q && \
    apt-get install -yq curl apt-transport-https ca-certificates gnupg unzip git jq sudo lsb-release \
    python3 python3-pip && \
    update-ca-certificates


# Install Teller Secrets Manager from a specific GitHub release\
RUN echo https://github.com/tellerops/teller/releases/download/v${TELLER_VERSION}/teller_${TELLER_VERSION}_Linux_x86_64.tar.gz
RUN curl -L https://github.com/tellerops/teller/releases/download/v${TELLER_VERSION}/teller_${TELLER_VERSION}_Linux_x86_64.tar.gz -o teller-linux-amd64.tar.gz 
RUN   tar -xzvf teller-linux-amd64.tar.gz
RUN    mv teller /usr/local/bin/teller
RUN    rm teller-linux-amd64.tar.gz


# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
