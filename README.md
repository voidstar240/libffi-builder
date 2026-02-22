# libffi Builder

This is a container for building libffi static and dynamic libraries.

## Usage
Run the included compose file or Dockerfile directly using your favorite
container runtime. Here `podman` is used.

`$ podman-compose run --rm libffi-builder`

Libraries with their headers will be in `data/libffi-VERSION/` directory.
This directory is packed into `data/libffi-VERSION.tar.gz`.
