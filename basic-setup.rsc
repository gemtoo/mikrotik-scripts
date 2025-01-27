/system note
set show-at-login=no
/system ntp client
set enabled=yes
/system ntp server
set enabled=yes manycast=yes multicast=yes
/system ntp client servers
add address=time.cloudflare.com
add address=pool.ntp.org
/system routerboard settings
set auto-upgrade=yes
/interface bridge settings
set use-ip-firewall=yes use-ip-firewall-for-pppoe=yes \
    use-ip-firewall-for-vlan=yes
/ipv6 settings
set accept-router-advertisements=no
