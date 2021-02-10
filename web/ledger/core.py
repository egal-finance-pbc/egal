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
    def create_account(self, username, password, first_name, last_name) -> models.Account:
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
        user = User.objects.create_user(username, password=password, first_name=first_name, last_name=last_name)
        return models.Account.objects.create(user=user, public_key=kp.public_key, secret=kp.secret)

    @staticmethod
    def create_keypair() -> stellar.Keypair:
        return stellar.Keypair.random()

    @staticmethod
    def get_account(pubkey: str) -> models.Account:
        return models.Account.objects.filter(public_key=pubkey).first()

    def get_account_balance(self, pubkey: str) -> str:
        account = self.server.accounts().account_id(pubkey).call()
        if len(account['balances']) > 0:
            return account['balances'][0]['balance']
        else:
            raise LedgerError('account missing balance')

    def make_payment(self, src, dst, amount, desc=None):
        src_account = self.get_account(src)
        if src_account is None:
            raise LedgerError('invalid source account')

        stellar_src_account = self.server.load_account(src)
        tx = stellar.TransactionBuilder(
            source_account=stellar_src_account,
        ).append_operation(stellar.operation.Payment(
            destination=dst,
            asset=stellar.Asset.native(),
            amount=amount,
        )).add_memo(stellar.TextMemo(str(desc))).build()
        stellar_src_keypair = stellar.Keypair.from_secret(src_account.secret)
        tx.sign(stellar_src_keypair)
        stellar_r = self.server.submit_transaction(tx)
        return stellar_r["_links"]["self"]["href"]


class LedgerError(Exception):
    def __init__(self, message, debug=None):
        self.message = message
        self.debug = debug
