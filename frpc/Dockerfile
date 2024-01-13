FROM alpine:3.19.0

LABEL maintainer="ilaipi <mz.yyam@gmail.com>"

ARG FRP_VERSION=0.53.2
ENV FRP_VERSION ${FRP_VERSION}

RUN mkdir -p /etc/frp \
    && cp ./frpc.toml /etc/frp/

RUN cd /root \
    &&  wget --no-check-certificate -c https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  tar zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz  \
    &&  cd frp_${FRP_VERSION}_linux_amd64/ \
    &&  cp frpc /usr/bin/ \
    &&  cd /root \
    &&  rm frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  rm -rf frp_${FRP_VERSION}_linux_amd64/ 

ENTRYPOINT /usr/bin/frpc

CMD ["-c", "/etc/frp/frpc.toml"]
