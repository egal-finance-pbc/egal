from decimal import Decimal

from django.conf import settings
from django.contrib.auth.models import User
from django.db import transaction
import requests
import stellar_sdk as stellar
from stellar_sdk import exceptions

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
        account = models.Account.objects.filter(public_key=pubkey).first()
        if account is None:
            raise LedgerError('account not found')
        return account

    def get_account_balance(self, pubkey: str) -> str:
        account = self.server.accounts().account_id(pubkey).call()
        if len(account['balances']) > 0:
            return account['balances'][0]['balance']
        else:
            raise LedgerError('account missing balance')

    @transaction.atomic
    def make_payment(self, src: models.Account, dst: str, amount: Decimal, desc=None) -> models.Payment:
        try:
            payment = models.Payment(
                destination=self.get_account(dst),
                amount=amount,
                source=src,
            )
            if desc is not None:
                payment.description = str(desc)
            payment.save()

            stellar_src_account = self.server.load_account(src.public_key)
            stellar_src_keypair = stellar.Keypair.from_secret(src.secret)
            fee = self.server.fetch_base_fee()
            tx = stellar.TransactionBuilder(
                network_passphrase=stellar.Network.TESTNET_NETWORK_PASSPHRASE,
                source_account=stellar_src_account,
                base_fee=fee,
            ).append_operation(stellar.operation.Payment(
                asset=stellar.Asset.native(),
                amount=str(amount),
                destination=dst,
            )).add_text_memo(str(payment.pk)).build()
            tx.sign(stellar_src_keypair)
            stellar_r = self.server.submit_transaction(tx)
            href = stellar_r["_links"]["self"]["href"]
            payment.transaction_url = href
            payment.save()
            return payment

        except exceptions.SdkError as e:
            logger.error('Payment transaction failed', repr=repr(e), str=str(e))
            raise LedgerError('failed to complete payment')


class LedgerError(Exception):
    def __init__(self, message, debug=None):
        self.message = message
        self.debug = debug
