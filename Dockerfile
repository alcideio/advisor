#
#  This image is also available on docker hub https://hub.docker.com/r/alcide/advisor/tags
#  Use alcide/advisor:stable
#

FROM alpine:latest AS build
RUN  apk --no-cache --update add wget ca-certificates

RUN wget -O /kube-advisor https://alcide.blob.core.windows.net/generic/stable/linux/advisor &&\
  chmod +x /kube-advisor


FROM scratch

WORKDIR /
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /kube-advisor /kube-advisor

ENTRYPOINT  ["/kube-advisor"]