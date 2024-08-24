FROM alpine
RUN mkdir /appdata
WORKDIR /appdata

RUN apk upgrade
RUN apk add --no-cache openssh openrc iproute2 tcpdump iperf nftables
RUN mkdir /run/openrc
RUN touch /run/openrc/softlevel
RUN rc-status

ENTRYPOINT ["/appdata/scripts/manage.sh"]
CMD ["init"]
