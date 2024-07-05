# syntax=docker/dockerfile:1

# BASE
# Creates a user and installs common system libraries.
FROM python:3.12-slim-bookworm AS base

# Create a user with explicit UID and GID.
# set -e: forces bash to fail on the first error, allowing you to separate commands with ;
# set -x: prints each executed command, making the output more comprehensible
RUN set -ex; \
    groupadd --gid 1000 app; \
    useradd --create-home --uid 1000 --gid app app

# Add system packages required to RUN your application here.
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      libmariadb3 \
    ; \
    rm -rf /var/lib/apt/lists/*


# PDM
# Installs PDM to a virtualenv. The virtualenv can be then mounted in other stages.
FROM base AS pdm

ARG PDM_VERSION=2.16.1

# Install PDM as non-privileged user.
USER app
RUN set -ex; \
    python -m venv /home/app/pdm; \
    . /home/app/pdm/bin/activate; \
    pip install --no-cache-dir "pdm==${PDM_VERSION}";


# BUILDER
# Creates a virtual environment with all dependencies.
FROM base AS builder

# Add system packages required to BUILD your application here.
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      default-libmysqlclient-dev \
    ; \
    rm -rf /var/lib/apt/lists/*

# Use a non-privileged user to install dependencies.
USER app

# Create a virtualenv and install dependencies.
RUN \
  --mount=type=bind,source=pyproject.toml,target=/home/app/pyproject.toml \
  --mount=type=bind,source=pdm.lock,target=/home/app/pdm.lock \
  --mount=type=bind,from=pdm,source=/home/app/pdm,target=/home/app/pdm \
    set -ex; \
    python -m venv /home/app/venv; \
    . /home/app/venv/bin/activate; \
    /home/app/pdm/bin/pdm --no-cache install --project /home/app/ --no-self --production --frozen-lockfile


# PRODUCTION
# Image containing the application.
FROM base AS production
USER app
WORKDIR /home/app/project

# Copy the virtual environment from the builder.
COPY --from=builder /home/app/venv /home/app/venv
ENV VIRTUAL_ENV="/home/app/venv" \
    PATH="/home/app/venv/bin:$PATH"

# Copy the entire application. You can copy only selected files and directories.
COPY . /home/app/project

# Install the application itself - there might be CLI scripts defined in the project's pyproject.toml.
# Running PDM install with already initialized venv and without --no-self will create the scripts.
RUN \
   --mount=type=bind,from=pdm,source=/home/app/pdm,target=/home/app/pdm \
    /home/app/pdm/bin/pdm --no-cache install --project /home/app/project --production --frozen-lockfile

# Install system updates.
USER root
RUN set -ex; \
    apt-get update; \
    apt-get upgrade -y; \
    rm -rf /var/lib/apt/lists/*
USER app

EXPOSE 8000
ENTRYPOINT ["docker/start-gunicorn.sh"]


# DEVELOPMENT
# Image with dev dependencies.
FROM production AS development

RUN \
   --mount=type=bind,from=pdm,source=/home/app/pdm,target=/home/app/pdm \
    /home/app/pdm/bin/pdm --no-cache install --project /home/app/project --dev --frozen-lockfile
