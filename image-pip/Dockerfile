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

USER app

RUN \
  --mount=type=bind,source=requirements.txt,target=/home/app/requirements.txt \
    set -ex; \
    python -m venv /home/app/venv; \
    . /home/app/venv/bin/activate; \
    pip install --no-cache-dir -r /home/app/requirements.txt


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
  --mount=type=bind,source=requirements-dev.txt,target=/home/app/requirements-dev.txt \
    pip install --no-cache-dir -r /home/app/requirements-dev.txt \
