import stellar_sdk as stellar


keypair = stellar.Keypair.random()

if __name__ == "__main__":
    print("Public key: " + keypair.public_key)
    print("Key secret: " + keypair.secret)
