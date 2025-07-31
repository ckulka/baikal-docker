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

> [!IMPORTANT]
> Username/password authentication using seems to be no longer available.
>
> For more details, see [Less secure apps & your Google Account](https://support.google.com/accounts/answer/6010255).

If you use Gmail as your SMTP server, you have create an app password:

1. Enable two-factor authentication (2FA): <https://myaccount.google.com/signinoptions/twosv>
2. Create an app password: <https://myaccount.google.com/u/0/apppasswords>

For more details on app passwords, see [Sign in with app passwords](https://support.google.com/accounts/answer/185833).

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

### DAVx5 but usernames are not an emails

When using DAVx5, then your Baikal usernames must be email addresses, otherwise email invitations will not be sent out.

For more details, see <https://manual.davx5.com/accounts_collections.html#account-names>.

Kodus to @deathblade666 for finding this out in <https://github.com/ckulka/baikal-docker/issues/290#issuecomment-3136438356>.
