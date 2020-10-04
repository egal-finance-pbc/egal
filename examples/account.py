import json

import requests
import stellar_sdk as stellar

import keypair as kp
import settings


r = requests.get(settings.FRIENDBOT_URL, params={
    "addr": kp.keypair.public_key
})

if r.status_code != 200:
    raise Exception("Error creating account: " + r.text)

server = stellar.Server(horizon_url=settings.HORIZON_URL)
account = server.accounts().account_id(kp.keypair.public_key).call()

if __name__ == "__main__":
    print("Account details: " + json.dumps(account))
