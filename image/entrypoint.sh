#!/bin/bash
set -e

echo "Running entrypoint.sh"

# Test if skopeo works with current capabilities
if ! skopeo  2>/dev/null; then
  # When running inside a normal Podman container with --device /dev/fuse we
  # need to remove the CAP_SYS_ADMIN capability from skopeo
  sudo setcap cap_sys_admin-ep /usr/bin/skopeo
fi

# # Creating fake docker.sock to podman.sock file so GitHub Actions image builder works.
# echo "Creating fake docker.sock to podman.sock file so GitHub Actions image builder works."
# sudo mkdir -p /run/podman
# sudo touch /run/podman/podman.sock

# # Create GitHub action directories if they don't exist
# # This helps when running Docker actions with Podman
# echo "Running mkdir -p ${HOME}/_work/_temp/_github_home"
# mkdir -p ${HOME}/_work/_temp/_github_home
# ls -l ${HOME}/_work/_temp/
# ls -l ${HOME}/_work/_temp/_github_home


# echo "Creating docker wrapper script"
# cat > /tmp/docker-wrapper.sh <<EOF
# #!/bin/bash

# ls -l ${HOME}/_work/_temp/

# # Extract volume mount paths from arguments
# # for arg in "\$@"; do
# #   if [[ \$arg == -v* || \$arg == --volume* ]]; then
# #     # Extract host path from volume mount
# #     host_path=\$(echo \$arg | cut -d':' -f1 | sed 's/^-v //; s/^--volume //')
# #     # Create directory if it doesn't exist
# #     echo "Creating directory \$host_path"
# #     mkdir -p \$host_path
# #   fi
# # done
# # Call the real podman command
# /usr/bin/podman "\$@"
# EOF

### Docker deamon section ###
# Start dockerd in the background and redirect output to a log file
sudo touch /var/log/dockerd.log && sudo chown $(whoami): /var/log/dockerd.log
sudo /usr/bin/dockerd > /var/log/dockerd.log 2>&1 &
DOCKERD_PID=$!

# Wait for docker to start
timeout=10000
while ! docker info >/dev/null 2>&1; do
  # Check if dockerd process is still running
  if ! ps -p $DOCKERD_PID > /dev/null; then
    echo "Docker daemon failed to start. Try adding --privileged to the container."
    break
  fi

  timeout=$((timeout - 100))
  if [ $timeout -eq 0 ]; then
    echo "WARNING: Docker daemon did not start within the timeout period."
    break
  fi
  sleep 0.1
done
### End of Docker deamon section ###

# Execute the command passed to the container
exec "$@"
