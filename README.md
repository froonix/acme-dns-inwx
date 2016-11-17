# ACME-DNS-INWX
Simple helper script for various [Let's Encrypt][1] clients.
Developed for [GetSSL][2], tested at Debian and Ubuntu.

## Initial setup
Download or clone the archive and extract it to a new folder.

Copy the example config file `config/.inwx.ini` to `~/.inwx.ini` and
insert your credentials. If enabled, enter your TOTP/2FA shared secret.
Don't forget to check file permissions! (recommended: 0600)

Run it for the first time:

```bash
# Add the TXT record _acme-challenge.example.com
# with value "test" and set TTL to 300 seconds:
./scripts/acme-dns-inwx "example.com" "test"

# Check your nameserver: (wait some time)
dig TXT "_acme-challenge.example.com" +short

# Delete the TXT record _acme-challenge.example.com:
./scripts/acme-dns-inwx --del "example.com"
```

Take a look at the wiki for more examples.

## Bugs? Feedback?
Open a new issue or drop me a line at cs@fnx.li! :-)

Important: This project is **not** affiliated to INWX GmbH!

## Important links...
* [INWX API](https://www.inwx.com/en/offer/api)
* [Bugtracker](https://github.com/froonix/acme-dns-inwx/issues)
* [Wiki pages](https://github.com/froonix/acme-dns-inwx/wiki)

[1]: https://letsencrypt.org/docs/client-options/
[2]: https://github.com/srvrco/getssl
