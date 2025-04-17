# Container image requirements

## Overview
This document is to be consumed by an AI coding assistant to update the `image/Dockerfile` for the container image. Make sure the AI assistant has web access to be able to download the official GitHub runner-images VM description document (called VM document).

Suggested prompt to the AI coding assistant:
```
Update image/Dockerfile using this requirements file.
```

## Requirements
Use the file `image/Dockerfile_template` as a base for generating the image/Dockerfile. Insert the package/tools installations in the middle (see "This section is AI generated")

1. Look at [VM document](https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md) for what packages to include. Include every tool (unless a tool does not make sense in a container image).
1. The VM document may have several version of each tool. Only install the latest or stable version of each tool.
1. Only use one `apt-get install` command for the main packages that are included in the Ubuntu base repositores.
Place each package on its own line. Sort the packages in alphabetical order. Do not include comments in the main 
`apt-get install` command.
1. Do not change the locale.
1. Do not have a dedicated `apt-get update -y` RUN command, instead include it at the start of any RUN command that runs `apt-get install`.
1. Do not make any last `apt-get clean` step. Instead make sure each RUN command run the recommended clean (like "rm -rf /var/lib/apt/lists/*") at the end of the command.
1. Don't forget to install helm.
1. Don't forget to install java (openjdk with all developer tools). Make that installation part of the main `apt-get install` command.
1. Do not include Minikube and other tools like that (for example Kind). It does not fit in a container image.
1. Some tools (like yq) need a custom installation.
1. Don't include docker, docker-compose, docker-buildx-plugin or docker-buildx-plugin because it does not work well inside a container.
1. Don't add any installation for podman or skopeo. They are already included the template Dockerfile.
1. For netcat, use the `netcat-openbsd` package.
1. Do not install libgconf nor libgconf-2-4
1. Include AWS CLI, Azure CLI and Google Cloud CLI
1. Include Ansible.
1. Node.js (latest LTS)
