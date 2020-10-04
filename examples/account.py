import json

import requests
import stellar_sdk as stellar

import keypair as kp


friendbot_url = "https://friendbot.stellar.org"
r = requests.get(friendbot_url, params={
    "addr": kp.keypair.public_key
})

if r.status_code != 200:
    raise Exception("Error creating account: " + r.text)

print("Account successfully created: " + json.dumps(r.json()))

horizon_url = "https://horizon-testnet.stellar.org"
server = stellar.Server(horizon_url=horizon_url)

account = server.accounts().account_id(kp.keypair.public_key).call()
print("Account details: " + json.dumps(account))
