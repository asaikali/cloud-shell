FROM ubuntu:22.04

RUN apt-get update -y && apt-get install -y \
  jq \
  git \
  curl \
  a-certificates \
  python3 python3-pip \
  direnv  \
  apt-transport-https \
  gnupg \
  sudo \
 && update-ca-certificates 

#
# Configure direnv 
#
RUN echo 'eval "$(direnv hook bash)"' >> ~/.bashrc 

#
# install aws cli 
# 
RUN pip3 install awscli

#
# Install carvel tools
# 
RUN curl -L https://carvel.dev/install.sh | bash

#
# Install pivnet cli
#
RUN curl -L https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1 > /usr/local/bin/pivnet \
 && chmod +x /usr/local/bin/pivnet 

#
# Install kubectl
#
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

# 
# Install gcloud cli 
# 
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y
      
# RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg
# RUN curl https://sdk.cloud.google.com | bash 
