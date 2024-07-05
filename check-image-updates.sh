#!/usr/bin/env bash

IMAGE="${1}"

if [ -z "${IMAGE}" ]
then
  printf "Error: Missing image to check!\n\n"
  printf "This script allows you to check if there are any security updates that can be applied in the given image.\n\n"
  printf "Usage:\n"
  printf "  %s [IMAGE]\n\n" "${0}"
  printf "Exit codes:\n"
  printf "  0: if there is at least one update that can be applied.\n"
  printf "  1: if there are no updates to apply.\n"
  exit 1
fi

# Run a temporary container from the given image.
docker run --rm \
  --user root \
  --entrypoint /bin/bash \
  "${IMAGE}" \
  -c 'apt-get update -qq \
    && ( \
      apt-get upgrade --dry-run \
      | grep -E "\\(.* (Debian-Security:|Ubuntu:[^/]*/[^-]*-security)" \
    )'
