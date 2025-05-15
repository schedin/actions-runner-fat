#!/bin/bash
set -e

echo "Running entrypoint.sh"

# Test if skopeo works with current capabilities
if ! skopeo  2>/dev/null; then
  # When running inside a normal Podman container with --device /dev/fuse we
  # need to remove the CAP_SYS_ADMIN capability from skopeo
  sudo setcap cap_sys_admin-ep /usr/bin/skopeo
fi

# Creating fake docker.sock to podman.sock file so GitHub Actions image builder works.
echo "Creating fake docker.sock to podman.sock file so GitHub Actions image builder works."
sudo mkdir -p /run/podman
sudo touch /run/podman/podman.sock

# # Create GitHub action directories if they don't exist
# # This helps when running Docker actions with Podman
# echo "Running mkdir -p ${HOME}/_work/_temp/_github_home"
# mkdir -p ${HOME}/_work/_temp/_github_home
# ls -l ${HOME}/_work/_temp/
# ls -l ${HOME}/_work/_temp/_github_home


echo "Creating docker wrapper script"
cat > /tmp/docker-wrapper.sh <<EOF
#!/bin/bash

ls -l ${HOME}/_work/_temp/

# Extract volume mount paths from arguments
# for arg in "\$@"; do
#   if [[ \$arg == -v* || \$arg == --volume* ]]; then
#     # Extract host path from volume mount
#     host_path=\$(echo \$arg | cut -d':' -f1 | sed 's/^-v //; s/^--volume //')
#     # Create directory if it doesn't exist
#     echo "Creating directory \$host_path"
#     mkdir -p \$host_path
#   fi
# done
# Call the real podman command
/usr/bin/podman "\$@"
EOF

chmod +x /tmp/docker-wrapper.sh
sudo rm /usr/bin/docker
sudo mv /tmp/docker-wrapper.sh /usr/bin/docker


# Execute the command passed to the container
exec "$@"
