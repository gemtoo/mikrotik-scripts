/ip firewall mangle
add action=add-dst-to-address-list address-list=Our_WAN_address_list \
    address-list-timeout=30s chain=prerouting comment=\
    "Dynamically add our WAN address(es) to list" connection-nat-state=srcnat \
    in-interface-list=WAN_interface_list
/ip firewall nat
add action=masquerade chain=srcnat comment=\
    "WAN masquerade rule" dst-address-list=\
    !LANs out-interface-list=WAN_interface_list \
    src-address-list=LANs
add action=masquerade chain=srcnat comment=\
    "VPN masquerade rule" out-interface-list=\
    VPN_interface_list
add action=redirect chain=dstnat comment=\
    "Redirect all DNS queries to this MikroTik router" dst-port=53 protocol=\
    udp
add action=redirect chain=dstnat comment=\
    "Redirect all NTP queries to this MikroTik router" dst-port=123 \
    protocol=udp
add action=redirect chain=srcnat comment=\
    "Universal TCP hairpin source NAT" \
    dst-address-list=LANs dst-port=0-65535 protocol=tcp \
    src-address-list=LANs
add action=redirect chain=srcnat comment=\
    "Universal UDP hairpin source NAT" \
    dst-address-list=LANs dst-port=0-65535 protocol=udp \
    src-address-list=LANs
add action=dst-nat chain=dstnat comment="Nginx port forwarding example" \
    dst-port=80,443 in-interface-list=WAN_interface_list protocol=tcp \
    to-addresses=10.11.12.13
add action=dst-nat chain=dstnat comment="Nginx hairpin destination NAT example" \
    dst-address-list=Our_WAN_address_list dst-port=80,443 protocol=tcp \
    src-address-list=LANs to-addresses=10.11.12.13
