#!/bin/bash
set -e

# Test if skopeo works with current capabilities
if ! skopeo  2>/dev/null; then
  # When running inside a normal Podman container with --device /dev/fuse we
  # need to remove the CAP_SYS_ADMIN capability from skopeo
  sudo setcap cap_sys_admin-ep /usr/bin/skopeo
fi

# Create GitHub action directories if they don't exist
# This helps when running Docker actions with Podman
mkdir -p ${HOME}/_work/_temp/_github_home

# Execute the command passed to the container
exec "$@"
