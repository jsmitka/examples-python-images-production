#!/usr/bin/env bash

exec gunicorn "my_app.wsgi:app" --bind "[::]:8000" --access-logfile "-" --error-logfile "-" "$@"
