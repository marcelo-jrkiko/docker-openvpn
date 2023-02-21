FROM ubuntu:latest

RUN apt update
RUN apt install curl gpg -y
RUN curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/openvpn-repo-public.gpg
RUN echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/openvpn-repo-public.gpg] https://build.openvpn.net/debian/openvpn/release/2.6 kinetic main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
RUN apt update
RUN apt install openvpn iptables bash easy-rsa iputils-ping iproute2 tcpdump ulogd2 -y
RUN ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin  
RUN rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

COPY ./ulogd.conf /etc/ulogd.conf

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/tcp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
