# 2023-08-10 23:20:39 by RouterOS 7.10.2

/ip dns
set allow-remote-requests=yes cache-size=4096KiB doh-max-concurrent-queries=\
    100 max-concurrent-queries=120 max-concurrent-tcp-sessions=30 \
    use-doh-server=https://dns.nextdns.io/fd88ba verify-doh-cert=yes
/ip dns static
add address=103.199.17.192 comment=Ultralow name=dns.nextdns.io
add address=203.162.172.59 name=dns.nextdns.io
add address=45.90.28.217 comment="Anycast IPv4" disabled=yes name=\
    dns.nextdns.io
add address=45.90.30.217 disabled=yes name=dns.nextdns.io
add address=2a07:a8c0:: comment="Anycast IPv6" disabled=yes name=\
    dns.nextdns.io type=AAAA
add address=2a07:a8c1:: disabled=yes name=dns.nextdns.io type=AAAA

/system scheduler
add interval=1m name=NextDNS1 on-event="/tool netwatch add host=203.162.172.59\
    \_type=tcp-conn down-script=\"/ip dns static enable [find address=45.90.30\
    .217]\" up-script=\"/ip dns static disable [find address=45.90.30.217] \" \
    " policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-10 start-time=02:09:30
add interval=1m name=NextDNS2 on-event="/tool netwatch add host=203.162.172.59\
    \_type=tcp-conn down-script=\"/ip dns static enable [find address=45.90.28\
    .217]\" up-script=\"/ip dns static disable [find address=45.90.28.217] \" \
    " policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-10 start-time=02:09:30
add interval=1m name=NextDNS3 on-event="/tool netwatch add host=103.199.17.192\
    \_type=tcp-conn down-script=\"/ip dns static enable [find address=45.90.30\
    .217]\" up-script=\"/ip dns static disable [find address=45.90.30.217] \" \
    " policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-10 start-time=02:09:30
add interval=1m name=NextDNS4 on-event="/tool netwatch add host=103.199.17.192\
    \_type=tcp-conn down-script=\"/ip dns static enable [find address=45.90.28\
    .217]\" up-script=\"/ip dns static disable [find address=45.90.28.217] \" \
    " policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-10 start-time=02:09:30
add interval=1m name=NetWatchClean on-event=\
    "/system script run netwatch-cleaner" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-10 start-time=02:09:35
add interval=1m name=CheckDownAnexiaHan on-event="/tool netwatch\r\
    \nadd disabled=no down-script=\\\r\
    \n    \":log error \\\"[NextDNS] Error: Anexia-han was down\\\"\" host=203\
    .162.172.59 \\\r\
    \n    http-codes=\"\" test-script=\"\" type=tcp-conn up-script=\"\"" \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-10 start-time=02:09:30
add interval=1m name=CheckDownGreencloudHan on-event="/tool netwatch\r\
    \nadd disabled=no down-script=\\\r\
    \n    \":log error \\\"[NextDNS] Error: Greencloud-han was down\\\"\" host\
    =103.199.17.192 \\\r\
    \n    http-codes=\"\" test-script=\"\" type=tcp-conn up-script=\"\"" \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2023-08-10 start-time=02:09:30
/system script
add dont-require-permissions=no name=netwatch-cleaner owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local netwatchList [/tool netwatch find where status!=\"\"]\r\
    \n:foreach netwatchId in=\$netwatchList do={\r\
    \n    /tool netwatch remove \$netwatchId\r\
    \n}"

