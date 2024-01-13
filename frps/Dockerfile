FROM alpine:3.19.0

LABEL maintainer="ilaipi <mz.yyam@gmail.com>"

ARG FRP_VERSION=0.53.2
ENV FRP_VERSION ${FRP_VERSION}

RUN cd /root \
    &&  wget --no-check-certificate -c https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  tar zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz  \
    &&  cd frp_${FRP_VERSION}_linux_amd64/ \
    &&  cp frps /usr/bin/ \
    &&  cd /root \
    &&  rm frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  rm -rf frp_${FRP_VERSION}_linux_amd64/ 

COPY ./frps.toml /etc/frp/

ENTRYPOINT /usr/bin/frps

CMD ["-c", "/etc/frp/frps.toml"]
