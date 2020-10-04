import stellar_sdk as stellar

import account
import keypair
import settings

server = stellar.Server(horizon_url=settings.HORIZON_URL)
payer = server.load_account(account.account["id"])

payee_kp = stellar.Keypair.random()
transaction = stellar.TransactionBuilder(
    source_account=payer,
    network_passphrase=stellar.Network.TESTNET_NETWORK_PASSPHRASE,
    base_fee=100
).append_create_account_op(
    destination=payee_kp.public_key,
    starting_balance="1"
).build()

transaction.sign(keypair.keypair)
response = server.submit_transaction(transaction)

print("Payee account created: " + payee_kp.public_key)
