# Use Ubuntu 22.04 (Jammy) as the base image
FROM ubuntu:22.04

# Install common utilities and update ca-certificates
RUN apt-get update -q && \
    apt-get install -yq \
      locales \
      curl \
      apt-transport-https \
      ca-certificates \
      gnupg \
      unzip  \
      git \
      jq \
      sudo \
      lsb-release \
      bash-completion \
      python3 python3-pip && \
    update-ca-certificates

# Set the locale to en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install direnv
RUN apt-get install -yq direnv && \
    echo 'eval "$(direnv hook bash)"' >> /etc/bash.bashrc

# Install Tanzu CLI
RUN curl -fsSL https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub | sudo gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg && \
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-os-packages/apt tanzu-cli-jessie main" | sudo tee /etc/apt/sources.list.d/tanzu.list && \
sudo apt-get update -q && \
sudo apt-get install -yq tanzu-cli

# Install Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update -q && \
    apt-get install -yq google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg && \
    . /etc/lsb-release && \
    echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/ ${DISTRIB_CODENAME} main" > \
    /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update -q && \
    apt-get install -yq azure-cli

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    sudo ./aws/install && \
    rm awscliv2.zip

# Install Carvel and command completions
RUN curl -L https://carvel.dev/install.sh | bash && \
    kapp completion bash > /etc/bash_completion.d/kapp && \
    kctrl completion bash > /etc/bash_completion.d/kctrl && \
    imgpkg completion bash > /etc/bash_completion.d/imgpkg && \
    ytt completion bash > /etc/bash_completion.d/ytt && \
    vendir completion bash > /etc/bash_completion.d/vendir 

# Install kubectl and alias it to k and activate command completion for kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    echo 'alias k="kubectl"' >> /etc/bash.bashrc && \
    echo 'source <(kubectl completion bash)' >> /etc/bash.bashrc

# Install PivNet CLI using the specified version
ARG PIVNET_VERSION=3.0.0
RUN curl -LO https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} && \
    chmod +x pivnet-linux-amd64-${PIVNET_VERSION} && \
    mv pivnet-linux-amd64-${PIVNET_VERSION} /usr/local/bin/pivnet

# Install Teller Secrets Manager 
ARG TELLER_VERSION=1.5.6
RUN curl -L https://github.com/tellerops/teller/releases/download/v${TELLER_VERSION}/teller_${TELLER_VERSION}_Linux_x86_64.tar.gz -o teller-linux-amd64.tar.gz && \
    tar -xzvf teller-linux-amd64.tar.gz && \
    mv teller /usr/local/bin/teller && \
    rm teller-linux-amd64.tar.gz

# Install CUE language
ARG CUE_VERSION=0.6.0 
RUN curl -L https://github.com/cue-lang/cue/releases/download/v${CUE_VERSION}/cue_v${CUE_VERSION}_linux_amd64.tar.gz -o cue.tar.gz && \
    mkdir cue && \
    tar -xzvf cue.tar.gz -C cue && \
    mv cue/cue /usr/local/bin/cue && \
    rm cue.tar.gz && \
    rm -rf cue

# Install k9s 
ARG K9S_VERSION=0.27.4
RUN curl -LO https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz && \
    tar -xzvf k9s_Linux_amd64.tar.gz && \
    mv k9s /usr/local/bin/ && \
    rm k9s_Linux_amd64.tar.gz

# Install kubectl-tree plugin
ARG KUBECTL_TREE_VERSION=0.4.3
RUN curl -L https://github.com/ahmetb/kubectl-tree/releases/download/v${KUBECTL_TREE_VERSION}/kubectl-tree_v${KUBECTL_TREE_VERSION}_linux_amd64.tar.gz -o kubectl-tree.tar.gz && \
    tar -xzvf kubectl-tree.tar.gz && \
    mv kubectl-tree /usr/local/bin/  && \
    rm kubectl-tree.tar.gz

# Install kubens 
ARG KUBENS_VERSION=0.9.5
RUN curl -L https://github.com/ahmetb/kubectx/releases/download/v${KUBENS_VERSION}/kubens_v${KUBENS_VERSION}_linux_x86_64.tar.gz -o kubens.tar.gz && \
    tar -xzvf kubens.tar.gz && \
    mv kubens /usr/local/bin/ && \
    rm kubens.tar.gz

# Install kubectx
ARG KUBECTX_VERSION=0.9.5
RUN curl -L https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz -o kubectx.tar.gz && \
    tar -xzvf kubectx.tar.gz && \
    mv kubectx /usr/local/bin/ && \
    rm kubectx.tar.gz

# Install bash-it
RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && \
    ~/.bash_it/install.sh --silent

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
