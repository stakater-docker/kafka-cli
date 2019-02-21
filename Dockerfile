FROM stakater/java-centos:7-1.8

ENV KAFKA_VERSION=1.0.2
ENV KAFKA_URL=http://mirrors.sonic.net/apache/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz
ENV KAFKA_TMP_DEST=/opt/kafka.tgz
ENV KAFKA_WORKDIR=/opt/kafka

USER root 

RUN yum update -y

RUN yum install -y jq

ADD run.sh /opt/run.sh

RUN chmod +x /opt/run.sh && \
    wget $KAFKA_URL -O ${KAFKA_TMP_DEST} && \
    mkdir -p ${KAFKA_WORKDIR} && \
    tar -xvzpf ${KAFKA_TMP_DEST} --strip-components=1 -C ${KAFKA_WORKDIR} && \
    chown -R 10001 ${KAFKA_WORKDIR} \
      && chown -R 10001 /opt/run.sh

# Again using non-root user i.e. stakater as set in base image
USER 10001

WORKDIR [ "/opt" ]
ENTRYPOINT [ "/opt/run.sh" ]