# Email Guide

This guide outlines the email configuration so that you can send out email invitations. Many thanks to [@philippneugebauer](https://github.com/philippneugebauer), [@vaskozl](https://github.com/vaskozl), [ahgraber](https://github.com/ahgraber), and everyone in [#61](https://github.com/ckulka/baikal-docker/discussions/61) for contributing.

In order to send out emails, you need a working SMTP service - you can host your own or rely on a service such as [Gmail](https://support.google.com/mail/answer/7126229?hl=en#zippy=%2Cstep-change-smtp-other-settings-in-your-email-client).

The entire email configuration is stored in the `MSMTPRC` environment variable.

> [!Tip]
> After you have set up your configuration, you can run a quick test by sending an email from the command line.
>
> This is especially helpful when you do not receive emails from Baikal and you want to narrow down the error.
>
> 1. Start your Baikal container with the SMTP configuration
> 1. Open a command prompt inside the Baikal container
>
>    ```sh
>    docker exec -it <conatiner_name> /bin/sh
>    ```
>
> 1. Send an email
>
>    ```sh
>    echo "Hello world." | msmtp -a default your-email-address@example.com
>    ```

## Generic SMTP server

If you have an SMTP server without security in place, i.e. no authentication or SSL/TLS/STARTTLS, then you only have to configure the SMTP server name. Needless to say it's highly recommended to have authentication and TLS in place.

```yaml
# docker-compose.yaml
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
# docker-compose.yaml
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
# docker-compose.yaml
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

## Known issues

### Baikal username is not an email address

@deathblade666 found out that Baikal uses the username as the email address, see <https://github.com/ckulka/baikal-docker/issues/290#issuecomment-3136438356>.

Until the issue is fixed, your usernames must also be their email addresses, otherwise they will not receive email invitations.
