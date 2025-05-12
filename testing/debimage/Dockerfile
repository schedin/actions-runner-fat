FROM debian:bookworm
 
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends podman fuse-overlayfs slirp4netns uidmap

RUN useradd podman -s /bin/bash && \
    echo "podman:1001:64535" > /etc/subuid && \
    echo "podman:1001:64535" > /etc/subgid

ARG _REPO_URL="https://raw.githubusercontent.com/containers/image_build/refs/heads/main/podman"
ADD $_REPO_URL/containers.conf /etc/containers/containers.conf
ADD $_REPO_URL/podman-containers.conf /home/podman/.config/containers/containers.conf

RUN mkdir -p /home/podman/.local/share/containers && \
    chown podman:podman -R /home/podman && \
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

USER podman
WORKDIR /home/podman