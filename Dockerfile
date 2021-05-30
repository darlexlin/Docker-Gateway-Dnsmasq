FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# 环境变量
ENV PUID PGID
ENV TZ Asia/Shanghai

# 软件版本
ARG V2RAY="v4.39.1"
ARG ADGUARDHOME="v0.106.3"

WORKDIR /tmp

# 下载并安装V2ray
RUN apt update && \
    apt install -y wget tzdata openssl ca-certificates unzip iptables vlan iputils-ping vim dnsmasq cron && \
    mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray && \
    wget -q -O v2ray.zip "https://github.com/v2fly/v2ray-core/releases/download/${V2RAY}/v2ray-linux-64.zip" && \
    unzip v2ray.zip && \
    chmod +x v2ray v2ctl && \
    mv v2ray v2ctl /usr/bin/ && \
    mv geosite.dat geoip.dat /usr/local/share/v2ray/ && \
    mv config.json /etc/v2ray/config.json && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt clean

# 下载AdGuard Home
RUN wget -q -O AdGuardHome.tar.gz "https://github.com/AdguardTeam/AdGuardHome/releases/download/${ADGUARDHOME}/AdGuardHome_linux_amd64.tar.gz" && \
    tar -zxvf AdGuardHome.tar.gz && \
    mkdir -p /defaults/AdGuardHome && \
    mv /tmp/AdGuardHome/* /defaults/AdGuardHome && \
    rm -rf /tmp/*

# 下载dnsmasq-chinalist
RUN mkdir -p /defaults/dnsmasq/dnsmasq.d && \
    wget -P /defaults/dnsmasq/dnsmasq.d https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf && \
    wget -P /defaults/dnsmasq/dnsmasq.d https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf && \
    wget -P /defaults/dnsmasq/dnsmasq.d https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf && \
    wget -P /defaults/dnsmasq/dnsmasq.d https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf

# 添加本地文件
COPY root/ /

# 设置ChinaIP List的自动更新
RUN mv /defaults/chinaip/ChinaIP.sh /etc/cron.daily && \
    chmod +x /etc/cron.daily/ChinaIP.sh

WORKDIR /config
