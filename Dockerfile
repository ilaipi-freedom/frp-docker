FROM alpine:3.19.0

LABEL maintainer="ilaipi <mz.yyam@gmail.com>"

ARG FRP_VERSION=0.61.1
ARG SERVER_HOST
ARG SERVER_PORT=7000
ARG REMOTE_SERVER_PORT=7000
ARG AUTH_TOKEN
ARG ROOT_DOMAIN_NAME
ARG FRP_DASHBOARD_ADDR=0.0.0.0
ARG FRP_DASHBOARD_PORT=7500
ARG FRP_DASHBOARD_USERNAME=admin
ARG FRP_DASHBOARD_PASSWORD=admin

ARG CONF_FILE_NAME=frpc

ENV FRP_VERSION ${FRP_VERSION}
ENV CONF_FILE_NAME ${CONF_FILE_NAME}

RUN cd /root \
    &&  wget --no-check-certificate -c https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  tar zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz  \
    &&  cd frp_${FRP_VERSION}_linux_amd64/ \
    &&  cp ${CONF_FILE_NAME} /usr/bin/ \
    &&  cd /root \
    &&  rm frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  rm -rf frp_${FRP_VERSION}_linux_amd64/ 

COPY ./${CONF_FILE_NAME}.toml /etc/frp/
RUN sed -i "s/SERVER_HOST/${SERVER_HOST}/g" /etc/frp/${CONF_FILE_NAME}.toml \
    && sed -i "s/SERVER_PORT/${SERVER_PORT}/g" /etc/frp/${CONF_FILE_NAME}.toml \
    && sed -i "s/REMOTE_SERVER_PORT/${REMOTE_SERVER_PORT}/g" /etc/frp/frpc.toml \
    && sed -i "s/AUTH_TOKEN/${AUTH_TOKEN}/g" /etc/frp/${CONF_FILE_NAME}.toml \
    && sed -i "s/ROOT_DOMAIN_NAME/${ROOT_DOMAIN_NAME}/g" /etc/frp/${CONF_FILE_NAME}.toml \
    && sed -i "s/FRP_DASHBOARD_ADDR/${FRP_DASHBOARD_ADDR}/g" /etc/frp/${CONF_FILE_NAME}.toml \
    && sed -i "s/FRP_DASHBOARD_PORT/${FRP_DASHBOARD_PORT}/g" /etc/frp/${CONF_FILE_NAME}.toml \
    && sed -i "s/FRP_DASHBOARD_USERNAME/${FRP_DASHBOARD_USERNAME}/g" /etc/frp/${CONF_FILE_NAME}.toml \
    && sed -i "s/FRP_DASHBOARD_PASSWORD/${FRP_DASHBOARD_PASSWORD}/g" /etc/frp/${CONF_FILE_NAME}.toml

ENTRYPOINT /usr/bin/${CONF_FILE_NAME} -c /etc/frp/${CONF_FILE_NAME}.toml
