/ip dns set servers=1.1.1.1,1.0.0.1
/tool fetch url=https://curl.se/ca/cacert.pem
/certificate import file-name=cacert.pem passphrase=""
/ip dns set use-doh-server=https://1.1.1.1/dns-query verify-doh-cert=yes
/ip dns set servers=""
/file remove cacert.pem
