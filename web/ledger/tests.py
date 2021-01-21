from unittest.mock import Mock, patch

from django.contrib.auth import authenticate
from django.test import TestCase

from . import core


class TestGateway(TestCase):
    def test_create_stellar_keypair(self):
        gateway = core.Gateway()
        keypair = gateway.create_keypair()
        self.assertEqual(56, len(keypair.public_key))
        self.assertEqual(56, len(keypair.secret))

    @patch('requests.get')
    def test_create_account_and_duplicate(self, mg):
        # Mocking successful Stellar response
        mg.return_value = Mock(status_code=200)
        gateway = core.Gateway()
        gateway.create_keypair = Mock(return_value=Mock(
            public_key='lorem', secret='ipsum'
        ))  # Mocking keypair to test set attributes
        a1 = gateway.create_account('a1', 'pwd', 'foo', 'bar')
        self.assertEqual('lorem', a1.public_key)
        self.assertEqual('ipsum', a1.secret)
        self.assertEqual('a1', a1.user.username)
        self.assertEqual('foo', a1.user.first_name)
        self.assertEqual('bar', a1.user.last_name)
        self.assertIsNotNone(authenticate(username='a1', password='pwd'))
        # Duplicate account creation throws an error
        with self.assertRaisesMessage(core.LedgerError, 'account already exists'):
            gateway.create_account('a1', 'pwd', 'bar', 'baz')

    @patch('requests.get')
    def test_create_account_with_stellar_error(self, mg):
        # Mocking unsuccessful Stellar response
        mg.return_value = Mock(status_code=500, text='stellar is down')
        # Trying to create account
        gateway = core.Gateway()
        with self.assertRaises(core.LedgerError) as mgr:
            gateway.create_account('a1', 'pwd', 'foo', 'bar')
        self.assertEqual('account creation failed', mgr.exception.message)
        self.assertEqual('stellar is down', mgr.exception.debug)
