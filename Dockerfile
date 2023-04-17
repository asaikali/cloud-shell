FROM ubuntu:22.04
RUN apt-get update -y \ 
 && apt-get install -y jq git curl ca-certificates python3 python3-pip  \
 && update-ca-certificates 
RUN pip3 install awscli
RUN curl -L https://carvel.dev/install.sh | bash
RUN curl -L https://github.com/pivotal-cf/pivnet-cli/releases/download/v3.0.1/pivnet-linux-amd64-3.0.1 > /usr/local/bin/pivnet \
 && chmod +x /usr/local/bin/pivnet 
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

