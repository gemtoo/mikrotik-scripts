/queue type
add kind=cake \
    name=cake-rx \
    cake-diffserv=besteffort \
    cake-flowmode=srchost \
    cake-rtt-scheme=internet \
    cake-nat=yes
add kind=cake \
    name=cake-tx \
    cake-ack-filter=filter \
    cake-diffserv=besteffort \
    cake-flowmode=dsthost \
    cake-rtt-scheme=internet \
    cake-nat=yes

/queue simple
add name=queue1 \
    max-limit=90M/45M \
    queue=cake-rx/cake-tx \
    target=PPPoE_WAN
