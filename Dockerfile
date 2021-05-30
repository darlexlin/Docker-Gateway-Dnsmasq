FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# 环境变量
ENV PUID PGID
ENV TZ Asia/Shanghai

# 软件版本
ARG ADGUARDHOME="v0.106.3"

WORKDIR /tmp

# 下载并安装dnsmasq
RUN apt update && \
    apt install -y wget tzdata openssl ca-certificates unzip iputils-ping vim dnsmasq && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt clean

# 自定义dnsmasq配置
RUN echo 'conf-dir=/config/dnsmasq/dnsmasq.d'>>/etc/dnsmasq.conf

# 下载AdGuard Home
RUN apt update && \
    wget -q -O AdGuardHome.tar.gz "https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARDHOME}/AdGuardHome_linux_amd64.tar.gz" && \
    tar -zxvf AdGuardHome.tar.gz && \
    mkdir -p /defaults/AdGuardHome && \
    mv /tmp/AdGuardHome/* /defaults/AdGuardHome && \
    rm -rf /tmp/*

# 下载gfwlist2dnsmasq分流文件
RUN apt update && \
    wget -q -O gfwlist.conf "https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist.conf" && \
    mkdir -p /defaults/dnsmasq/dnsmasq.d && \
    mv /tmp/gfwlist.conf /defaults/dnsmasq/dnsmasq.d/gfwlist.conf && \
    rm -rf /tmp/*

# 添加本地文件
COPY root/ /

WORKDIR /config

EXPOSE 3000 53/udp
VOLUME /config
