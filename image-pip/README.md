# Example Docker Image: PDM

Example of a production Docker image for an application that uses pip to install dependencies.

* Multi-stage build with separate build and production stages.
* Uses pip to install dependencies.
* Application runs as a non-privileged user.
* Installs system updates to get the latest bug fixes and security updates.

See the `Dockerfile` for a detailed walk-through.


## Building the image

Use the following command to build the production image:

```bash
docker buildx build --target production --tag example-image-pip:latest .
```

You can also add the `--progress plain` argument to see the complete build log.


## Running the example

Provided `docker-compose.yml` allows you to start the application in two configurations: production (`example_prod`),
and development (`example_dev`).

Run them with the following command:

```bash
docker compose up --build
```

You can verify that the application works on the following links:

* Production: http://localhost:8000/
* Development: http://localhost:8001/
