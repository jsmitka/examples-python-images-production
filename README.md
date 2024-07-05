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
