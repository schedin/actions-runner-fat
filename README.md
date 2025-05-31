# Fat Actions Runner
This is a build container image that can be used to build applications, for example jar files. It can also build container images. The advantage of a build container is that the build is deterministic. It also simplifies installation of build servers.

This container image is intended to be used by a self-hosted runner with the Actions Runner Controller (ARC) in Kubernetes, or standalone as a general purpose build container.
See [Managing self-hosted runners with Actions Runner Controller](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller).
It tries to be compatible with the official GitHub Actions Runner image: `ghcr.io/actions/actions-runner:latest` (see [Dockerfile for actions-runner](https://github.com/actions/runner/tree/main/images)).
This image has included most of the tools that exist in the [official GitHub Actions runner Ubuntu VM image](https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md).

The `latest` tag of this image is built weekly for latest security updates.

https://github.com/user-attachments/assets/c718148e-08bc-4ad9-a3ed-9c951fa992c7

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
    --set template.spec.containers[0].args[0]="/home/runner/run.sh" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```

### Building containers or executing GitHub Docker container actions
Docker, Podman, Skopeo and Buildah are included in the image to enable building and pushing container images.

A Docker daemon is started and can be used both for building/pushing images and for executing GitHub Docker container actions.

To be able to use the container features, the Pod spec needs the `--privileged` flag set. For example, insert this line into the Helm command above:
```bash
    --set template.spec.containers[0].securityContext.privileged=true \
```

> [!NOTE]
> It is possible to mount `/dev/fuse` instead of using the `--privileged` flag for Podman. But it is complicated to achieve in Kubernetes because it is not natively supported (see [#92114](https://github.com/kubernetes/kubernetes/issues/92114) and [#7890](https://github.com/kubernetes/kubernetes/issues/7890)).


## Configuration/Environment Variables

Example of setting environment variables in the Helm command:
```bash
    --set template.spec.containers[0].env[0].name=DISABLE_DOCKER_SERVICE \
    --set template.spec.containers[0].env[0].value=true \
```

Example of setting environment variables using Podman or Docker:
```bash
docker run --rm -it -e DISABLE_DOCKER_SERVICE=true ghcr.io/schedin/actions-runner-fat:latest
```

| Variable | Default | Description |
|----------|---------|-------------|
| `DISABLE_DOCKER_SERVICE` | `false` | When set to `true`, prevents the Docker daemon from starting. Useful where you only need Podman or want to reduce resource usage. |

## Container vs. VM Considerations
This container is designed to be a lightweight alternative to the GitHub-hosted runners while still providing essential tools for CI/CD workflows. Unlike the full GitHub Actions VM image, which includes multiple versions of each tool and language, this container focuses on providing the latest stable version of each tool to keep the image size manageable.
