# acme-dns-inwx
ALPHA RELEASE! DON'T USE IT!

## getssl.conf
```
VALIDATE_VIA_DNS="true"
DNS_ADD_COMMAND=~/scripts/acme-dns-inwx.wrapper add
DNS_DEL_COMMAND=~/scripts/acme-dns-inwx.wrapper del

DNS_WAIT=10
DNS_EXTRA_WAIT=60

#CHECK_ALL_AUTH_DNS="true"
AUTH_DNS_SERVER="ns1.fnx.li"
```
