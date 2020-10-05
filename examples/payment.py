import json

import stellar_sdk as stellar

from account import account as payer_account
from keypair import keypair as payer_keypair
import settings


server = stellar.Server(horizon_url=settings.HORIZON_URL)
payer = server.load_account(payer_account["id"])
print("Payer initial balances: " + json.dumps(payer_account["balances"]))

# Payee account creation.
payee_keypair = stellar.Keypair.random()
transaction = stellar.TransactionBuilder(
    source_account=payer,
    network_passphrase=stellar.Network.TESTNET_NETWORK_PASSPHRASE,
    base_fee=100
).append_create_account_op(
    destination=payee_keypair.public_key,
    starting_balance="1"
).build()

transaction.sign(payer_keypair)
print("Creating payee account...")
response = server.submit_transaction(transaction)
payee_account = server.accounts().account_id(payee_keypair.public_key).call()
print("Payee account created: " + payee_account["_links"]["self"]["href"])
print("Payee account balances: " + json.dumps(payee_account["balances"]))

print("Getting payer balance again...")
payer_account = server.accounts().account_id(payer_account["id"]).call()
print("Payer balances after payee creation: " + json.dumps(payer_account["balances"]))

# Payment execution.
print("Making payment...")
payment_transaction = stellar.TransactionBuilder(
    source_account=payer
).append_operation(stellar.operation.Payment(
    destination=payee_account["id"],
    asset=stellar.Asset.native(),
    amount="299"
)).add_memo(stellar.TextMemo("Test payment")).build()

payment_transaction.sign(payer_keypair)
payment_response = server.submit_transaction(payment_transaction)
print("Payment complete: " + payment_response["_links"]["self"]["href"])

# Final balances.
payee_account = server.accounts().account_id(payee_account["id"]).call()
print("Final payee balances: " + json.dumps(payee_account["balances"]))
payer_account = server.accounts().account_id(payer_account["id"]).call()
print("Final payer balances: " + json.dumps(payer_account["balances"]))
