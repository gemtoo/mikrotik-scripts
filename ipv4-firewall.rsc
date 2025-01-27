/ip firewall address-list
add address=10.0.0.0/8 list=LANs
add address=192.168.0.0/16 list=LANs
add address=172.16.0.0/12 list=LANs
/ip firewall filter
add action=accept chain=input comment=\
    "Accept established, related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="Drop invalid for input" \
    connection-state=invalid
add action=accept chain=input comment="Accept ICMP ping" protocol=icmp
add action=drop chain=input comment=\
    "Drop WinBox connections from blacklisted IPs" dst-port=8291 protocol=tcp \
    src-address-list=Blacklisted_IPs
add action=accept chain=input comment="Accept WinBox connections" dst-port=\
    8291 protocol=tcp
add action=accept chain=input comment="Accept DNS queries from LAN" dst-port=\
    53 in-interface-list=LAN_interface_list protocol=udp
add action=accept chain=input comment="Accept NTP queries from LAN" dst-port=\
    123 in-interface-list=LAN_interface_list protocol=udp
add action=drop chain=input comment="Drop everything else"
add action=fasttrack-connection chain=forward comment="Fasttrack connections" \
    connection-state=established,related hw-offload=yes
add action=accept chain=forward comment=\
    "Accept established, related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="Drop invalid for forward" \
    connection-state=invalid
add action=drop chain=forward comment="Drop all from WAN not DSTNATed" \
    connection-nat-state=!dstnat connection-state=new in-interface-list=\
    WAN_interface_list
/ip firewall mangle
add action=add-dst-to-address-list address-list=Blacklisted_IPs \
    address-list-timeout=1d chain=output comment=\
    "Add non-LAN bruteforcers to blacklist for 1 day" content=\
    "invalid user name or password" protocol=tcp src-address-list=!LANs \
    src-port=8291
/ip firewall nat
add action=masquerade chain=srcnat comment="WAN masquerade rule." \
    dst-address-list=!LANs out-interface-list=WAN_interface_list \
    src-address-list=LANs
add action=masquerade chain=srcnat comment="VPN masquerade rule." \
    out-interface-list=VPN_interface_list
add action=redirect chain=dstnat comment=\
    "Redirect all DNS queries to this MikroTik router." dst-port=53 \
    in-interface-list=LAN_interface_list protocol=udp
add action=redirect chain=dstnat comment=\
    "Redirect all NTP queries to this MikroTik router." dst-port=123 \
    in-interface-list=LAN_interface_list protocol=udp
/ip firewall service-port
set ftp disabled=yes
set tftp disabled=yes
set h323 disabled=yes
set sip disabled=yes
set pptp disabled=yes
/ip upnp
set show-dummy-rule=no
