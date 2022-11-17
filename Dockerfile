FROM alpine:latest

ARG TARGETOS
ARG TARGETARCH

ENV ENCRYPTED_ONLY 0

RUN apk update && apk add --no-cache supervisor && mkdir -p /opt/rustdesk  && mkdir /public && mkdir /data

ADD build-dir/${TARGETOS}/${TARGETARCH}/gohttpserver /opt/rustdesk/gohttpserver
ADD build-dir/${TARGETOS}/${TARGETARCH}/hbbr /opt/rustdesk/hbbr
ADD build-dir/${TARGETOS}/${TARGETARCH}/hbbs /opt/rustdesk/hbbs
ADD build-dir/${TARGETOS}/${TARGETARCH}/rustdesk-utils /opt/rustdesk/rustdesk-utils

ADD supervisord.conf /etc/supervisord.conf

ADD start-gohttpserver.sh /start-gohttpserver.sh
ADD get-key-daemon.sh /get-key-daemon.sh
ADD start-hbbr.sh /start-hbbr.sh
ADD start-hbbs.sh /start-hbbs.sh

ADD start.sh /start.sh

ADD windowsclientID.ps1 /public/windowsclientID.ps1
ADD clientinstall.ps1 /public/clientinstall.ps1

ADD WindowsAgentAIOInstall.ps1 /data/WindowsAgentAIOInstall.ps1
ADD linuxclientinstall.sh /data/linuxclientinstall.sh

VOLUME ["/public"]
VOLUME ["/kes"]

EXPOSE 21115 21116 21116/udp 21117 21118 21119 8080

WORKDIR /

CMD ["/bin/sh", "/start.sh"]
