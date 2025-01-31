ARG BUILDPLATFORM=

FROM --platform=${BUILDPLATFORM:-linux/amd64} ubuntu:focal

ARG NOSLATE_URL= \
    NODE_VERSION=

LABEL org.opencontainers.image.authors="noslate-support@@list.alibaba-inc.com" \
      org.opencontainers.image.source="https://github.com/noslate-project/noslate" \
      org.opencontainers.image.licenses="MIT"

# set envionment variables
ENV NOSLATE_PATH=/usr/local/noslate \
    NOSLATE_WORKDIR=/.noslate

ENV NOSLATE_BIN=${NOSLATE_PATH}/bin \
    ALICE_WORKDIR=${NOSLATE_WORKDIR}/alice \
    TURF_WORKDIR=${NOSLATE_WORKDIR}/turf \
    LIBTURF_PATH=${NOSLATE_WORKDIR}/bin/libturf.so \
    NOSLATE_LOGDIR=${NOSLATE_WORKDIR}/logs

RUN apt-get update && \
    apt-get install -y libatomic1 unzip procps curl && \
    rm -rf /var/lib/apt/lists/*

# mkdirs
RUN mkdir -p ${NOSLATE_PATH} && \
    mkdir -p ${NOSLATE_WORKDIR} && \
    mkdir -p ${ALICE_WORKDIR} && \
    mkdir -p ${ALICE_WORKDIR}/caches && \
    mkdir -p ${ALICE_WORKDIR}/bundles && \
    mkdir -p ${TURF_WORKDIR} && \
    mkdir -p ${TURF_WORKDIR}/overlay && \
    mkdir -p ${TURF_WORKDIR}/runtime && \
    mkdir -p ${TURF_WORKDIR}/runtime/aworker/bin && \
    mkdir -p ${TURF_WORKDIR}/runtime/nodejs-v16/bin && \
    mkdir -p ${TURF_WORKDIR}/sandbox && \
    chmod -R 777 ${NOSLATE_WORKDIR} && \
    chmod -R 555 ${TURF_WORKDIR}/runtime

# install noslate and requirements
RUN curl -sLo ./noslate.tar.gz ${NOSLATE_URL} && \
    tar -zxvf noslate.tar.gz -C ${NOSLATE_PATH} && \
    chmod +x ${NOSLATE_BIN}/turf && \
    chmod +x ${NOSLATE_BIN}/aworker && \
    chmod +x ${NOSLATE_BIN}/node && \
    ln -s ${NOSLATE_BIN}/turf /usr/local/bin/turf && \
    ln -s ${NOSLATE_BIN}/aworker /usr/local/bin/aworker && \
    ln -s ${NOSLATE_BIN}/aworker.shell /usr/local/bin/aworker.shell && \
    ln -s ${NOSLATE_BIN}/node /usr/local/bin/node && \
    rm -f noslate.tar.gz
