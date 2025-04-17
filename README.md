# Fat Actions Runner
This container image is intended to be used by a self-hosted runner with the Actions Runner Controller (ARC) in Kubernetes.
See [Managing self-hosted runners with Actions Runner Controller](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller).
It is built upon the official GitHub Actions Runner image: `ghcr.io/actions/actions-runner:latest` (see [Dockerfile for actions-runner](https://github.com/actions/runner/tree/main/images)).
This image has included most of the tools that exist in the official GitHub Actions runner Ubuntu VM image.

## Building the Image
To build the container image locally:

```bash 
docker build -t actions-runner-fat:latest image/.
```

## Using with Actions Runner Controller (ARC)
To use this image with ARC, update your Helm install command for your scale set to this image instead of the default. For example:
```bash
INSTALLATION_NAME="arc-runner-set"
NAMESPACE="arc-runners"
GITHUB_CONFIG_URL="https://github.com/<your_enterprise/org/repo>"
GITHUB_PAT="<PAT>"
helm upgrade --install "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE}" \
    --set githubConfigUrl="${GITHUB_CONFIG_URL}" \
    --set githubConfigSecret.github_token="${GITHUB_PAT}" \
    --set template.spec.containers[0].name=runner \
    --set template.spec.containers[0].image=ghcr.io/schedin/actions-runner-fat:latest \
    --set template.spec.containers[0].command[0]="/home/runner/run.sh" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```

### Building containers inside the runner
Podman and Skopeo are included in the image to enable building and pushing container images. The package podman-docker (a Docker-compatible CLI interface) is also installed so most `docker` commands can be used seamlessly. To be able to build container image the Pod spec needs the `--privileged` flag set. For example insert this line into the Helm command above:
```bash
      --set template.spec.containers[0].securityContext.privileged=true \
```

## Container vs. VM Considerations
This container is designed to be a lightweight alternative to the GitHub-hosted runners while still providing essential tools for CI/CD workflows. Unlike the full GitHub Actions VM image, which include multiple versions of each tool and language, this container focuses on providing the latest stable version of each tool to keep the image size manageable.
