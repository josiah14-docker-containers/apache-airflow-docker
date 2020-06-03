# Dockerized Airflow

## Abstract

This is an iterative project to dockerize Airflow (yet again, because why not?).  Effort starts with the Sequential Executor and will progress to getting the Local Executor working, and then either Celery or the Kubernets Executor next, depending on priority which will be assessed at a later date.

## Prerequisite System Dependencies

You need to have Docker Engine CE installed.

## Building the Container

```bash
# from the root directory of this project...
docker build -t josiah14-airflow .
```

### Validating the Build

```bash
docker images

# You should see a row that looks similar to the following:
josiah14-airflow   latest   d79a0ff785b8   About a minute ago   908MB
```

## Running the Container

```bash
# -i specifies interactive, -t specifies a TTY connection,
# --rm specifies to delete the container after stopping it,
# -p forwards port 8080 on the host to port 8080 in the container,
# /bin/bash executes a bash shell through the TTY connection.
docker run -it --rm -p 8080:8080 josiah14-airflow:latest /bin/bash
```

### Running Airflow

```bash
# These commands should be run from the bash shell on the container that
# the above `run` command will drop you into...

airflow scheduler &

# Wait until you see some text print to the console indicating the Scheduler is up.

airflow webserver &
```

### Interacting with Airflow

You can interact now with the Airflow UI from `localhost:8080` on your host machine
using any modern web browser (or cURL, or whatever you want).

You may also execute commands using the Airflow CLI from the container's Bash shell
that you're connected to through the TTY session.
