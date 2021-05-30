## start
#!/bin/sh

## Download ChinaIP form https://ispip.clang.cn

URL=https://ispip.clang.cn/all_cn_cidr.txt
TMP_DIR=/tmp

cd $TMP_DIR

curl -s $URL |sed -e '/^#.*/d' -e 's/^/add address=/g' -e 's/$/ list=ChinaIP/g'|sed -e $'1i\\\n/ip firewall address-list' -e $'1i\\\nremove [/ip firewall address-list find list=ChinaIP]' -e $'1i\\\nadd address=10.0.0.0/8 list=ChinaIP comment=private-network' -e $'1i\\\nadd address=172.16.0.0/12 list=ChinaIP comment=private-network' -e $'1i\\\nadd address=192.168.0.0/16 list=ChinaIP comment=private-network' |sed '$a \/' |sed '$a /file remove ChinaIP.rsc'>ChinaIP.rsc
