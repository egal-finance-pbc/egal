from django.conf import settings
from django.contrib.auth.models import User
from django.db import transaction
import requests
import stellar_sdk as stellar

from . import models
from conellas import logging


logger = logging.get_logger(__name__)


class Gateway:
    def __init__(self):
        self.server = stellar.Server(horizon_url=settings.STELLAR_HORIZON_URL)

    @transaction.atomic
    def create_account(self, username, first_name, last_name) -> models.Account:
        if User.objects.filter(username=username).exists():
            raise LedgerError('account already exists')
        kp = self.create_keypair()
        # Funding the account with Friendbot.
        r = requests.get(settings.STELLAR_FRIENDBOT_URL, params={
            'addr': kp.public_key
        })
        if r.status_code != 200:
            logger.error('Failed to fund stellar account', addr=kp.public_key, error=r.text)
            raise LedgerError('account creation failed', r.text)
        user = User.objects.create_user(username, first_name=first_name, last_name=last_name)
        return models.Account.objects.create(user=user, public_key=kp.public_key, secret=kp.secret)

    @staticmethod
    def create_keypair() -> stellar.Keypair:
        return stellar.Keypair.random()


class LedgerError(Exception):
    def __init__(self, message, debug=None):
        self.message = message
        self.debug = debug
