FROM debian:buster-slim

RUN apt-get update && apt-get install -y \
    bash \
    apt-utils \
    wait-for-it \
    make \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

ARG DOCKER_UID=1000
#Create the runner/runner with desired uid/home
RUN addgroup runner \
    && mkdir /home/runner /runner /work \
    && useradd -g runner --home /home/runner --uid $DOCKER_UID runner \
    && chown runner:runner /home/runner \
    && chown runner:runner /runner \
    && chown runner:runner /work

ENV GHACTIONS_RUNNER_VERSION=2.277.1

WORKDIR /runner


RUN curl -sLf "https://github.com/actions/runner/releases/download/v${GHACTIONS_RUNNER_VERSION}/actions-runner-linux-x64-${GHACTIONS_RUNNER_VERSION}.tar.gz" -o actions-runner.tar.gz\
    && tar -xzf actions-runner.tar.gz \
    && rm actions-runner.tar.gz \
    && ./bin/installdependencies.sh \
    && chown -R runner:runner /runner

COPY docker-entrypoint.sh /docker-entrypoint.sh

USER runner
