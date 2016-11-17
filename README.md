# ACME-DNS-INWX
Simple helper script for various [Let's Encrypt][1] clients.
Developed and tested for [GetSSL][2], a simple Bash-Client.

## Initial setup
Download or clone the archive and extract it to a new folder.

Copy the example config file `config/.inwx.ini` to `~/.inwx.ini` and
change username/password to your values. If enabled, enter your TOTP/2FA
shared secret. Don't forget to check file permissions! (recommended: 0600)

Run it for the first time:

```
scripts/.... add example
del example
```

## Bugs? Feedback?
Open a new issue or drop me a line at cs@fnx.li! :-)

## Important links...
* [Bugtracker](https://github.com/froonix/acme-dns-inwx/issues)
* [Wiki pages](https://github.com/froonix/acme-dns-inwx/wiki)

[1]: https://letsencrypt.org/docs/client-options/
[2]: https://github.com/srvrco/getssl
