# Python Docker Image Examples

This repository contains examples of Dockerfiles for Python applications. These examples show how to use multi-stage
build to create a Docker image suitable for production deployments.

There are several examples, each in its subfolder. Each example contains a minimal Flask application with
a single view and HTML template. However, each example uses a different tool to manage the dependencies.

Dockerfiles use a selected package manager to build a production image that contains only dependencies
required to run the application. Files required to install and compile the packages are kept in a separate stage.

Furthermore, an additional stage is included for installing development dependencies,
which can be used during development.

You are welcome to use these examples as a starting point for your projects. No attribution is required.


## Dockerfile examples

Examples are written for the following package managers:

* [PDM](https://pdm-project.org/en/latest/): [`image-pdm`](image-pdm/) subfolder.
* [pip](https://pip.pypa.io/en/stable/): [`image-pip`](image-pip/) subfolder.
* [Poetry](https://python-poetry.org): [`image-poetry`](image-poetry/) subfolder.
* [uv](https://github.com/astral-sh/uv): [`image-uv`](image-uv/) subfolder.

See the `README.md` in each subfolder for more information and instructions on running the example.

Don't see your favourite tool? Create an issue and I will try to add an example for it!


## Checking for security updates in an existing Docker image

This repository also includes a script to check if there are any security updates for your existing Docker image.
The script can be used in a scheduled job to trigger image rebuild when new security updates are released.

This script works for all images based on Debian or Ubuntu. Other Linux distributions are not supported.

To use this script, call:

```bash
./check-image-updates.sh <image tag>
```

The script terminates with exit code 0 if there is at least one security update that can be applied, and exit code
1 if there are no security updates.
