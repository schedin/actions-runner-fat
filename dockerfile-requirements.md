# Container image requirements

## Overview
This document is to be consumed by an AI coding assistent to update the `image/Dockerfile` for the container image. Make sure the AI assistent has web access to be able to download the official GitHub runner-images VM description document (called VM document).

## Requerments
1. Use the latest official GitHub Actions runner image (`ghcr.io/actions/actions-runner:latest`) as the base.
1. Temporary switch to user `root` to enable package installation and switch back to the base image user `runner` at the end.
1. Set `DEBIAN_FRONTEND=noninteractive` during package installations to prevent interactive prompts and unset it at the end.
1. Look at [VM document](https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2204-Readme.md) for what packages to include.
1. The VM document may have several version of each tool. Only install the latest or stable version of each tool.
1. Try to limit the amount if `apt-get install` invocations. But also try to comment and group related installations together.
1. Do not change the locale from the base image.
