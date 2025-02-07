/ipv6 firewall address-list
add address=::/128 comment="Unspecified address" list=Bad_IPv6_address_list
add address=::1/128 comment=Localhost list=Bad_IPv6_address_list
add address=fec0::/10 comment=Site-local list=Bad_IPv6_address_list
add address=::ffff:0.0.0.0/96 comment=IPv4-mapped list=Bad_IPv6_address_list
add address=::/96 comment="IPv4 compat" list=Bad_IPv6_address_list
add address=100::/64 comment="Discard only " list=Bad_IPv6_address_list
add address=2001:db8::/32 comment=Documentation list=Bad_IPv6_address_list
add address=2001:10::/28 comment=ORCHID list=Bad_IPv6_address_list
add address=3ffe::/16 comment=6bone list=Bad_IPv6_address_list
add address=::224.0.0.0/100 comment=Other list=Bad_IPv6_address_list
add address=::127.0.0.0/104 comment=Other list=Bad_IPv6_address_list
add address=::/104 comment=Other list=Bad_IPv6_address_list
add address=::255.0.0.0/104 comment=Other list=Bad_IPv6_address_list
add address=fe80::/10 comment="Link-Local addresses" list=Link_Local
/ipv6 firewall filter
add action=accept chain=input comment=\
    "Accept established, related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="Drop invalid packets from WAN" \
    connection-state=invalid
add action=accept chain=input comment="Accept DHCPv6 Solicit/Request" \
    dst-port=546 in-interface=PPPoE_WAN protocol=udp
add action=accept chain=input comment="Allow DHCPv6 Advertise/Reply" \
    dst-port=546 in-interface=PPPoE_WAN protocol=udp src-address=\
    ff02::1:2/128
add action=accept chain=input comment="Allow ICMPv6" protocol=icmpv6
add action=accept chain=input comment="Allow UDP traceroute" port=33434-33534 \
    protocol=udp
add action=drop chain=input comment=\
    "Deny WinBox connections for blacklisted IPs" dst-port=8291 protocol=tcp \
    src-address-list=Blacklisted_IPs
add action=accept chain=input comment="Allow WinBox connections" dst-port=\
    8291 protocol=tcp
add action=accept chain=input comment="Allow DNS queries from LAN" dst-port=\
    53 in-interface-list=LAN_interface_list protocol=udp
add action=accept chain=input comment="Allow NTP queries from LAN" dst-port=\
    123 in-interface-list=LAN_interface_list protocol=udp
add action=drop chain=input comment="Drop everything else"
add action=fasttrack-connection chain=forward comment="Fasttrack connections" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "Accept established, related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="Drop invalid packets for forward" \
    connection-state=invalid
add action=drop chain=forward comment="Drop packets with bad src IPv6" \
    src-address-list=Bad_IPv6_address_list
add action=drop chain=forward comment="Drop packets with bad dst IPv6" \
    dst-address-list=Bad_IPv6_address_list
add action=drop chain=forward comment="RFC4890 drop hop-limit=1" hop-limit=\
    equal:1 protocol=icmpv6
add action=accept chain=forward comment="Accept ICMPv6 for forward" protocol=\
    icmpv6
add action=drop chain=forward comment=\
    "Drop everything else not coming from LAN" in-interface-list=\
    !LAN_interface_list
/ipv6 firewall mangle
add action=add-dst-to-address-list address-list=Blacklisted_IPs \
    address-list-timeout=14w2d chain=output comment=\
    "Add non-LAN bruteforcers to blacklist for 100 days" content=\
    "invalid user name or password" protocol=tcp src-address-list=Link_Local \
    src-port=8291
/ipv6 firewall nat
add action=redirect chain=dstnat comment=\
    "Redirect all DNS queries to this MikroTik router" dst-port=53 \
    in-interface-list=LAN_interface_list protocol=udp
add action=redirect chain=dstnat comment=\
    "Redirect all NTP queries to this MikroTik router" dst-port=123 \
    in-interface-list=LAN_interface_list protocol=udp
/ipv6 nd
set [ find default=yes ] ra-interval=10s-30s ra-lifetime=1m
/ipv6 nd prefix default
