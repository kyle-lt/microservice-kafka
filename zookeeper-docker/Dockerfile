FROM zookeeper:latest

ENV DOCKERFILE_ENV_VAR=DOCKERFILE_ENV_VAL

# AppD
RUN apt-get update
RUN apt-get install -y curl jq unzip
COPY downloadAgent.sh .
RUN ./downloadAgent.sh

