from django.conf import settings
import requests
import stellar_sdk as stellar


class Gateway:
    def __init__(self):
        self.server = stellar.Server(horizon_url=settings.STELLAR_HORIZON_URL)

    def create_account(self) -> None:
        kp = self.create_keypair()
        # Funding the account with Friendbot.
        r = requests.get(settings.STELLAR_FRIENDBOT_URL, params={
            'addr': kp.public_key
        })
        if r.status_code != 200:
            raise LedgerError('account creation failed', r.text)

    @staticmethod
    def create_keypair() -> stellar.Keypair:
        return stellar.Keypair.random()


class LedgerError(Exception):
    def __init__(self, message, debug=None):
        self.message = message
        self.debug = debug
