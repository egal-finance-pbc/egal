import logging
import os
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

    @locust.task
    def signup(self) -> None:
        if self.created:
            return
        r = self.client.post('/api/v1/accounts/', json=self.login)
        if r.status_code == 201:
            self.created = True
            logger.info('User %s created', self.login['username'])

    @locust.task
    def signin(self) -> None:
        if self.token is not None:
            return
        r = self.client.post('/api/v1/accounts/tokens/', json={
            'username': self.login['username'],
            'password': self.login['password'],
        })
        if r.status_code == 200:
            self.token = r.json()['token']
            logger.info('Got token %s for user %s', self.token, self.login['username'])
