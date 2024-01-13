FROM alpine:3.19.0

LABEL maintainer="ilaipi <mz.yyam@gmail.com>"

ARG FRP_VERSION=0.53.2
ARG SERVER_HOST
ARG SERVER_PORT=7000
ARG AUTH_TOKEN
ARG ROOT_DOMAIN_NAME
ARG FRP_DASHBOARD_ADDR=0.0.0.0
ARG FRP_DASHBOARD_PORT=7500
ARG FRP_DASHBOARD_USERNAME=admin
ARG FRP_DASHBOARD_PASSWORD=admin

ARG CONF_FILE_NAME=frpc.toml

ENV FRP_VERSION ${FRP_VERSION}

RUN cd /root \
    &&  wget --no-check-certificate -c https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  tar zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz  \
    &&  cd frp_${FRP_VERSION}_linux_amd64/ \
    &&  cp frpc /usr/bin/ \
    &&  cd /root \
    &&  rm frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  rm -rf frp_${FRP_VERSION}_linux_amd64/ 

COPY ./${CONF_FILE_NAME} /etc/frp/
RUN sed -i 's/SERVER_HOST/${{ secrets.SERVER_HOST }}/g' /etc/frp/${CONF_FILE_NAME} \
    && sed -i 's/SERVER_PORT/${{ secrets.SERVER_PORT }}/g' /etc/frp/${CONF_FILE_NAME} \
    && sed -i 's/AUTH_TOKEN/${{ secrets.AUTH_TOKEN }}/g' /etc/frp/${CONF_FILE_NAME} \
    && sed -i 's/ROOT_DOMAIN_NAME/${{ secrets.ROOT_DOMAIN_NAME }}/g' /etc/frp/${CONF_FILE_NAME} \
    && sed -i 's/FRP_DASHBOARD_ADDR/${{ secrets.FRP_DASHBOARD_ADDR }}/g' /etc/frp/${CONF_FILE_NAME} \
    && sed -i 's/FRP_DASHBOARD_PORT/${{ secrets.FRP_DASHBOARD_PORT }}/g' /etc/frp/${CONF_FILE_NAME} \
    && sed -i 's/FRP_DASHBOARD_USERNAME/${{ secrets.FRP_DASHBOARD_USERNAME }}/g' /etc/frp/${CONF_FILE_NAME} \
    && sed -i 's/FRP_DASHBOARD_PASSWORD/${{ secrets.FRP_DASHBOARD_PASSWORD }}/g' /etc/frp/${CONF_FILE_NAME}

ENTRYPOINT /usr/bin/frpc

CMD ["-c", "/etc/frp/frpc.toml"]
