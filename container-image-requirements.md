# Container image requirements

## Overview
This document is to be consumed by an AI coding assistent to update the `image/Dockerfile` for the container image. Make sure the AI assistent has web access to be able to download the official GitHub runner-images VM description document (called VM document).

Suggested prompt to the AI coding assistent:
```
Update image/Dockerfile using this requirements file.
```

## Requirements
1. Include a comment at the top of the file to indicate that this was AI generated based on this requirements file.
1. Use the latest official GitHub Actions runner image (`ghcr.io/actions/actions-runner:latest`) as the base.
1. Temporary switch to user `root` to enable package installation and switch back to the base image user `runner` at the end.
1. Set `DEBIAN_FRONTEND=noninteractive` during package installations to prevent interactive prompts and unset it at the end.
1. Look at [VM document](https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2204-Readme.md) for what packages to include. Include every tool (unless a tool does not make sense in a container image).
1. The VM document may have several version of each tool. Only install the latest or stable version of each tool.
1. Try only use one `apt-get install` invocations. But feel free to group and comment the packages in the same command.
1. Do not change the locale.
1. Do not make any last `apt-get clean` step. Instead make sure each RUN command run the recommended clean (like "rm -rf /var/lib/apt/lists/*") at the end of the command.
1. Do not have a separate dedicated `apt-get update -y` RUN command, instead include it at the start of a RUN command that runs `apt-get install`.
1. Don't forget to install helm.
1. Do not include Minikube and other tools like that (for example Kind). It does not fit in a container image.
1. Some tools (like yq) need a custom installation.
1. Don't include docker, docker-compose, docker-buildx-plugin or docker-buildx-plugin because it does not work well inside a container
1. Include Podman and Skopeo. Also include the podman-docker package to emulate docker commands to work with Podman.
