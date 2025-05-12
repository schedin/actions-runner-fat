FROM docker.io/library/ubuntu:24.04

# The base image will be using this user
ARG BASE_USER=runner

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends podman fuse-overlayfs slirp4netns uidmap ca-certificates

RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

RUN echo "${BASE_USER}:1002:64534" > /etc/subuid && \
    echo "${BASE_USER}:1002:64534" > /etc/subgid

ARG _REPO_URL="https://raw.githubusercontent.com/containers/image_build/refs/heads/main/podman"
ADD $_REPO_URL/containers.conf /etc/containers/containers.conf
ADD $_REPO_URL/podman-containers.conf /home/${BASE_USER}/.config/containers/containers.conf

RUN mkdir -p /home/${BASE_USER}/.local/share/containers && \
    chown ${BASE_USER}:${BASE_USER} -R /home/${BASE_USER} && \
    chmod 0644 /etc/containers/containers.conf

VOLUME /home/podman/.local/share/containers

# Replace setuid bits by proper file capabilities for uidmap binaries.
# See <https://github.com/containers/podman/discussions/19931>.
RUN apt-get install -y libcap2-bin && \
    chmod 0755 /usr/bin/newuidmap /usr/bin/newgidmap && \
    setcap cap_setuid=ep /usr/bin/newuidmap && \
    setcap cap_setgid=ep /usr/bin/newgidmap && \
    apt-get autoremove --purge -y libcap2-bin

ENV _CONTAINERS_USERNS_CONFIGURED=""

USER ${BASE_USER}
WORKDIR /home/${BASE_USER}
