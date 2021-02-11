import logging
import os
import random
import uuid

import locust

import helpers


logger = logging.getLogger()

API_URL = os.getenv('API_URL')

if API_URL is None:
    host = helpers.Host()
    API_URL = 'http://{}:5000'.format(host.gateway)


class APIUser(locust.HttpUser):
    wait_time = locust.between(0, 1)
    host = API_URL

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.settings = helpers.Settings.get_instance()
        username = str(uuid.uuid4())
        password, first, last, _, _ = username.split('-')
        self.login = {
            'username': username,
            'password': password,
            'first_name': first,
            'last_name': last,
        }
        self.created = False
        self.token = None
        self.me = None
        self.account = None

    @locust.task
    def signup(self) -> None:
        if self.created:
            return

        r = self.client.post('/api/v1/accounts/', json=self.login)
        if r.status_code == 201:
            self.created = True
            logger.info('%s account created', self.login['username'])

    @locust.task
    def signin(self) -> None:
        if self.token is not None:
            return

        r = self.client.post('/api/v1/tokens/', json={
            'username': self.login['username'],
            'password': self.login['password'],
        })
        if r.status_code == 200:
            self.token = r.json()['token']
            logger.info('%s token received', self.token)
        else:
            logger.error(r.text)

    @locust.task
    def me(self) -> None:
        if self.me is not None:
            return

        r = self.client.get('/api/v1/me/', headers={
            'Authorization': 'Token {}'.format(self.token),
        })
        if r.status_code == 200:
            self.me = r.json()
            self.settings.state.set(self.me['public_key'], self.me)
            logger.info(self.me)
        else:
            logger.error(r.text)

    @locust.task
    def account(self) -> None:
        if self.me is None:
            return

        tpl = '/api/v1/accounts/{id}/'
        r = self.client.get(tpl.format(id=self.me['public_key']), headers={
            'Authorization': 'Token {}'.format(self.token),
        }, name=tpl)
        if r.status_code == 200:
            self.account = r.json()
            logger.info('%s %s', self.me['public_key'], r.text)
        else:
            logger.error(r.text)

    @locust.task
    def payment(self) -> None:
        if self.account is None:
            return

        if len(self.settings.state.keys()) < 2:
            logger.info('Not enough accounts for payments')
            return

        dst_key = None
        while dst_key is None:
            c = random.choice(self.settings.state.keys())
            if c != self.me['public_key']:
                dst_key = c

        balance = float(self.account['balance'])
        amount = random.randint(1, int(balance/8))
        r = self.client.post('/api/v1/payments/', headers={
            'Authorization': 'Token {}'.format(self.token),
        }, data={
            'destination': dst_key,
            'amount': str(amount),
        })

        if r.status_code == 201:
            src_key = self.me['public_key']
            location = r.headers['Location']
            logger.info('${amount} payment [{location}] [{src} -> {dst}]'.format(
                amount=amount, location=location, src=src_key, dst=dst_key,
            ))
        else:
            logger.error(r.text)
