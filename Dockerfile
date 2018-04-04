FROM alpine

ARG binary

COPY $binary /postgres_exporter

RUN apk update && apk add bash && apk add curl && apk add jq && apk add openssl
ARG KMS_UTILS=0.2.1

ADD http://sodio.stratio.com/repository/paas/kms_utils/${KMS_UTILS}/kms_utils-${KMS_UTILS}.sh /kms_utils.sh

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 9187

ENTRYPOINT [ "/entrypoint.sh" ]
