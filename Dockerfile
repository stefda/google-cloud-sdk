FROM alpine:3.5
MAINTAINER David STEFAN <stefda@gmail.com>

ARG CLOUD_SDK_VERSION=157.0.0
ARG SHA256SUM=95b98fc696f38cd8b219b4ee9828737081f2b5b3bd07a3879b7b2a6a5349a73f

RUN apk --no-cache add curl python py-crcmod bash libc6-compat ca-certificates

ENV PATH /google-cloud-sdk/bin:$PATH
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    echo "${SHA256SUM}  google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" > google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 && \
    sha256sum -c google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz.sha256 && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image

VOLUME ["/root/.config"]

ENV DOCKER_CHANNEL edge
ENV DOCKER_VERSION 17.05.0-ce
RUN set -ex; \
      apk add --no-cache --virtual .fetch-deps \
      curl \
      tar \
    ; \
    curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz"; \
      tar --extract \
      --file docker.tgz \
      --strip-components 1 \
      --directory /usr/local/bin/ \
    ; \
    rm docker.tgz; \
    apk del .fetch-deps; \
    dockerd -v; \
    docker -v

CMD ["sh"]
