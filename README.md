# tap-shell

This repository contains a Dockerfile to create a container image with 
commonly needed utilities for working with cloud platforms and Kubernetes. 
Additionally, it provides a GitHub Codespaces development container that 
allows you to launch a live development environment directly from GitHub.

The container image  has all the utilities for needed to install 
Tanzu Application Platform.

## Included Tools

### Cloud
- **[Google Cloud CLI](https://cloud.google.com/sdk)**: A set of command-line tools for Google Cloud Platform.
- **[Azure CLI](https://github.com/Azure/azure-cli)**: Command-line interface for managing Azure resources.
- **[AWS CLI](https://github.com/aws/aws-cli)**: Command-line tool for managing AWS services.

### Kubernetes
- **[kubectl](https://github.com/kubernetes/kubectl)**: Kubernetes command-line tool for interacting with clusters.
- **[kubectl tree](https://github.com/ahmetb/kubectl-tree)**: A kubectl plugin to display resources in a tree-like structure.
- **[kubectx](https://github.com/ahmetb/kubectx)**: A utility to switch between Kubernetes contexts.
- **[kubens](https://github.com/ahmetb/kubectx)**: A utility to switch between Kubernetes namespaces.
- **[k9s](https://github.com/derailed/k9s)**: A terminal-based UI to interact with your Kubernetes clusters.
- **[Carvel](https://github.com/vmware-tanzu/carvel)**: Suite of command-line utilities for working with Kubernetes resources.

### Configuration
- **[CUE](https://github.com/cue-lang/cue)**: A configuration language designed to be simple, efficient, and expressive.
- **[jq](https://stedolan.github.io/jq/)**: A lightweight and flexible command-line JSON processor.
- **[yq](https://github.com/mikefarah/yq)**: A command-line YAML processor that provides a way to interact with YAML documents.

### Secrets Managment
- **[Teller](https://github.com/tellerops/teller)**: A tool for securely managing secrets and accessing them in your applications.

### Tanzu
- **[PivNet CLI](https://github.com/pivotal-cf/pivnet-cli)**: Command-line tool for interacting with Pivotal Network (PivNet).

## Using GitHub Codespaces Development Container

You can launch a live development environment directly from this repository 
using GitHub Codespaces. The provided `.devcontainer` directory contains 
configuration files that define the development environment.
Simply click the "Code" button above and choose "Open with Codespaces" 
to launch the environment in your browser.

## Building the Docker Image

To build the Docker image locally, navigate to the directory 
containing the Dockerfile and run:

```shell
docker build -t cloud-shell .
```

## Running the Container with Docker

To run a container using the image with Docker, execute:

```shell
docker run -it cloud-shell
```