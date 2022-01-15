# Email Guide

This guide outlines the email configuration so that you can send out email invitations. Many thanks to [@philippneugebauer](https://github.com/philippneugebauer), [@vaskozl](https://github.com/vaskozl), and everyone in [#61](https://github.com/ckulka/baikal-docker/discussions/61) for contributing.

In order to send out emails, you need a working SMTP service - you can host your own or rely on a service such as [Gmail](https://support.google.com/mail/answer/7126229?hl=en#zippy=%2Cstep-change-smtp-other-settings-in-your-email-client).

The entire email configuration is stored in the `MSMTPRC` environment variable.

## Generic SMTP server

If you have an SMTP server without security in place, i.e. no authentication or SSL/TLS/STARTTLS, then you only have to configure the SMTP server name. Needless to say it's highly recommended to have authentication and TLS in place.

```yaml
services:
  baikal:
    image: ckulka/baikal:nginx
    environment:
      MSMTPRC: |
        defaults
        account        default
        host           <smtp host>
        port           25
```

If you have TLS and authentication in place, add the following configuration parameters:

```yaml
services:
  baikal:
    image: ckulka/baikal:nginx
    restart: always
    environment:
      MSMTPRC: |
        defaults
        auth           on
        tls            on
        tls_trust_file /etc/ssl/certs/ca-certificates.crt
        account        default
        host           <smtp host>
        port           587
        from           baikal@example.com
        user           <user>
        password       <password>
```

See [examples/docker-compose.email.yaml](../examples/docker-compose.email.yaml) for a starter template.

## Gmail

If you use Gmail as your SMTP server, you have to first allow less secure apps (sendmail) to use Gmail, see [Less secure apps & your Google Account](https://support.google.com/accounts/answer/6010255?hl=en#zippy=).

Once that is done, use the following configuration:

```yaml
services:
  baikal:
    image: ckulka/baikal:nginx
    environment:
      MSMTPRC: |
        defaults
        auth           on
        tls            on
        tls_trust_file /etc/ssl/certs/ca-certificates.crt
        account        default
        host           smtp.gmail.com
        port           587
        from           <user>@gmail.com
        user           <user>
        password       <password>
```

See [examples/docker-compose.sendmail-gmail.yaml](../examples/docker-compose.email-gmail.yaml) for a starter template.
