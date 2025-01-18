# Home Assistant Fix

This guide explains how to apply the Home Assistant fix that resolves <https://github.com/ckulka/baikal-docker/issues/231> and <https://github.com/sabre-io/dav/issues/1318>.

In short, if you are using Home Assistant and see this issue, then follow this guide to fix it.

> This query is received by the Baïkal instance running on apache (on the same host) and apache unfortunately returns a 500 error:
>
> ```xml
> <d:error xmlns:d="DAV:" xmlns:s="http://sabredav.org/ns">
>   <s:sabredav-version>4.1.2</s:sabredav-version>
>   <s:exception>Sabre\\VObject\\ParseException</s:exception>
>   <s:message>This parser only supports VCARD and VCALENDAR files</s:message>
> </d:error>
> ```

As far as I can tell, credit for the fix goes to @deboutv who originally shared the code (<https://github.com/sabre-io/Baikal/issues/695#issuecomment-394112977>) and @elliottjohnson who tested it for Home Assistant (<https://github.com/sabre-io/dav/issues/1318#issuecomment-757380175>).

## Step-by-step Instructions

Set the environment variable `APPLY_HOME_ASSISTANT_FIX` to `true` to enable the fix.

If you use a `docker-compose.yml` file, then it would look similar to this:

```yaml
services:
  baikal:
    image: ckulka/baikal:nginx
    environment:
      APPLY_HOME_ASSISTANT_FIX: "true"
    # (...)
```

Once the container starts, check the logs to ensure that the Home Assistant fix has been applied successfully. Look for a message similar to:

```log
30-apply-home-assistant-fix.sh: info: Applying Home Assistant fix
30-apply-home-assistant-fix.sh: info: Applied Home Assistant fix
```
