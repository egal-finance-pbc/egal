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


class SignUpFlooder(locust.HttpUser):
    wait_time = locust.between(0.8, 1)
    host = API_URL

    @locust.task
    def signup(self) -> None:
        username = str(uuid.uuid4())
        pwd, first, last, _, _ = username.split('-')
        r = self.client.post('/api/v1/accounts/', json={
            'first_name': first,
            'last_name': last,
            'username': username,
            'password': pwd,
        })
