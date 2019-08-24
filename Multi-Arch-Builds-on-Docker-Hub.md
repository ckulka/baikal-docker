# Multi-arch builds on Docker Hub

The `dockerfiles` folder contains the Dockerfiles and [Custom build phase hooks](https://docs.docker.com/docker-hub/builds/advanced/#override-build-test-or-push-commands) to build all variants for all platforms, e.g. `amd64` and `arm32v7`, on Docker Hub.

More specifically, the hooks

- Register QEMU in the `pre_build` phase
- Build the image variants in the `build` phase
- Push all images in the `push` phase
- Update the multi-arch manifest in the `post_push` phase

The `post_push` hook generates and pushes the manifest which - simply put - is just a list of references to other images.

```yaml
# Manifest for ckulka/baikal:experimental which points to the amd64 and arm32v7 images
image: ckulka/baikal:experimental
manifests:
  - image: ckulka/baikal:experimental-apache-amd64
    platform:
      architecture: amd64
      os: linux
  - image: ckulka/baikal:experimental-apache-arm32v7
    platform:
      architecture: arm
      os: linux
      variant: v7
```

## References

For more details, see

- [ckulka/docker-multi-arch-example](https://github.com/ckulka/docker-multi-arch-example).
- [Advanced options for Autobuild and Autotest](https://docs.docker.com/docker-hub/builds/advanced/)
