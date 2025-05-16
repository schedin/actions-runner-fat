#!/bin/bash
set -e

# Test if skopeo works with current capabilities
if ! skopeo --version >/dev/null 2>&1; then
  # When running inside a normal Podman container with --device /dev/fuse we
  # need to remove the CAP_SYS_ADMIN capability from skopeo
  sudo setcap cap_sys_admin-ep /usr/bin/skopeo
fi

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
