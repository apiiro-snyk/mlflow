#FROM continuumio/miniconda3
#
#WORKDIR /app
#
#ADD . /app
#
#RUN apt-get update && \
#    # install prequired modules to support install of mlflow and related components
#    apt-get install -y nodejs npm default-libmysqlclient-dev build-essential curl postgresql-server-dev-all \
#    # cmake and protobuf-compiler required for onnx install
#    cmake protobuf-compiler yarn &&  \
#    # install required python packages
#    cd requirements && \
#    pip install -r dev-requirements.txt --no-cache-dir && \
#    # pip install -r test-requirements.txt --no-cache-dir && \
#    pip install psycopg2 && \
#    cd .. && \
#    # install mlflow in editable form
#    pip install --no-cache-dir -e . && \
#    # mkdir required to support install openjdk-11-jre-headless
#    mkdir -p /usr/share/man/man1 && apt-get install -y openjdk-11-jre-headless && \
#    # install npm for node.js support
##    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
#    cd mlflow/server/js && \
#    npm install --legacy-peer-deps && \
#    npm run build


FROM python:3.8

WORKDIR /app

ADD . /app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    # install prequired modules to support install of mlflow and related components
    apt-get install -y default-libmysqlclient-dev build-essential curl openjdk-11-jre-headless \
    # cmake and protobuf-compiler required for onnx install
    cmake protobuf-compiler &&  \
    # install required python packages \
    pip install psycopg2-binary && \
    pip install -r requirements/dev-requirements.txt --no-cache-dir && \
    # install mlflow in editable form
    pip install --no-cache-dir -e .

# Build MLflow UI
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    npm install --global yarn && \
    cd mlflow/server/js && \
    yarn install && \
    yarn build

RUN apt-get install -y tree

COPY script/start.sh /opt/mlflow/start.sh
RUN tree

