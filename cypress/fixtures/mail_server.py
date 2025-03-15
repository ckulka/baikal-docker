from email.message import Message as Em_Message
from aiosmtpd.handlers import Message
from aiosmtpd.controller import Controller

import asyncio
import logging
from aiohttp import web

received_emails = dict()

# Message handler that stores incoming mail in a dictionary by subject
class MyMessageHandler(Message):
    def handle_message(self, message: Em_Message) -> None:
        subject = message.get('SUBJECT')
        if subject not in received_emails:
            received_emails[subject] = []

        received_emails[subject].append({
            'fromAddress': message.get('FROM'),
            'toAddresses': message.get_all('TO'),
            'subject': subject,
            'body': message.get_payload()
        })

# Start the SMTP server
async def start_smtp(loop):
    cont = Controller(MyMessageHandler(), hostname='0.0.0.0', port=8025)
    cont.start()

# Start the API server
async def start_api(loop):
    app = web.Application()
    app.add_routes([web.get('/mail', handle)])
    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, '0.0.0.0', 8080)
    await site.start()

# Retrun the messages by subject
async def handle(request):
    subject = request.query.get('subject')

    if subject not in received_emails:
        return web.json_response({
            'totalRecords': 0,
            'mailItems': []
        })

    return web.json_response({
            'totalRecords': len(received_emails[subject]),
            'mailItems': received_emails[subject]
        })

# Starts the SMTP and API servers
if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.create_task(start_smtp(loop=loop))  # type: ignore[unused-awaitable]
    loop.create_task(start_api(loop=loop))  # type: ignore[unused-awaitable]
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        print("User abort indicated")
