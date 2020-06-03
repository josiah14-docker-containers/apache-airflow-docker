FROM ubuntu:20.04

RUN apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN apt-get update -y --fix-missing && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends apt-utils \
 && apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:deadsnakes/ppa \
 && apt-get update -y --fix-missing \
 && apt-get install -y python3.7 \
                       python3.7-dev \
                       sudo \
                       python3-pip \
                       stunnel4 \
                       cifs-utils \
                       vim \
                       iputils-ping \
                       wget \
                       curl \
                       telnet \
                       netcat \
                       dnsutils

# make 3.7 the default system Python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2 \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 \
  && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

ENV SLUGIFY_USES_TEXT_UNIDECODE=yes
ENV AIRFLOW_HOME=/opt/airflow

RUN mkdir -p ${AIRFLOW_HOME}

RUN pip3 install --upgrade pip

COPY ./master-requirements.txt /root/pip-dependencies/master-requirements.txt

# Below, I anticipate using the Celery executor with Postgres as the Flower and
# Executor backend (one db for each) and Redis as the Celery queuing service.
RUN pip3 install -U "apache-airflow==1.10.9" \
    && pip3 install -U "apache-airflow[celery]" "celery[redis]" psycopg2-binary
RUN cd /root
RUN pip3 install -U -r /root/pip-dependencies/master-requirements.txt
RUN rm -rf /root/pip-dependencies
RUN useradd airflow
RUN airflow initdb ; true

RUN chown -R airflow:airflow ${AIRFLOW_HOME}

RUN apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# USER airflow  # After hardening, there should not be a way to sudo in the container or log in as root
