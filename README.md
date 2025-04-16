# actions-runner-fat
This container image is intended to be used by self-hosted GitHub Actions runner in Kubernetes.
See [Managing self-hosted runners with Actions Runner Controller](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller).

## Base Image
This image builds upon the official GitHub Actions runner image: `ghcr.io/actions/actions-runner:latest`. See [Dockerfile for actions-runner](https://github.com/actions/runner/tree/main/images).

## Building the Image

To build the container image locally:

```bash
docker build -t actions-runner-fat:latest image/.
```

## Using with Actions Runner Controller (ARC)

To use this image with ARC, update your Helm install command to use this images instead of the default. For example:
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
