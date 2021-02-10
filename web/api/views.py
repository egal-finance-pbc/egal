from rest_framework import status
from rest_framework.exceptions import (
    ParseError, APIException, ValidationError, NotFound, PermissionDenied
)
from rest_framework.response import Response
from rest_framework.throttling import AnonRateThrottle
from rest_framework.views import APIView

from conellas.logging import get_logger
from ledger.core import Gateway, LedgerError
from . import serializers


SIGNUP_THROTTLE_SCOPE = 'signup'


logger = get_logger(__name__)


class SignUpThrottle(AnonRateThrottle):
    rate = '60/minute'
    scope = SIGNUP_THROTTLE_SCOPE


class Accounts(APIView):
    """View to manage a collection of accounts."""

    throttle_classes = [SignUpThrottle]
    throttle_scope = SIGNUP_THROTTLE_SCOPE

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.ledger = Gateway()

    def post(self, request):
        logger.info('Received signup request', remote_addr=request.META.get('REMOTE_ADDR'),
                    x_forwarded_for=request.META.get('HTTP_X_FORWARDED_FOR'))

        payload = serializers.SignUp(data=request.data)
        if not payload.is_valid():
            raise ParseError()

        try:
            account = self.ledger.create_account(
                first_name=payload.validated_data['first_name'],
                last_name=payload.validated_data['last_name'],
                username=payload.validated_data['username'],
                password=payload.validated_data['password'],
            )
            return Response(status=status.HTTP_201_CREATED)

        except LedgerError as e:
            raise APIException(detail=e.message, code=status.HTTP_500_INTERNAL_SERVER_ERROR)


class Account(APIView):
    """View to manage a single account resource."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.ledger = Gateway()

    def get(self, request, pubkey=None):
        if request.user.is_anonymous:
            raise PermissionDenied()

        if not pubkey:
            raise ValidationError()

        try:
            account = self.ledger.get_account(pubkey)
            if account is None:
                raise NotFound()

            if account.user.id != request.user.id:
                raise PermissionDenied()

            balance = self.ledger.get_account_balance(pubkey)
            return Response(data={
                'balance': balance,
            })

        except LedgerError as e:
            raise APIException(detail=e.message)


class Me(APIView):
    """View to inspect user information."""
    def get(self, request):
        if request.user.is_anonymous:
            raise PermissionDenied()

        account = getattr(request.user, 'account')
        if account is None:
            raise NotFound()

        return Response(data={
            'username': request.user.username,
            'first_name': request.user.first_name,
            'last_name': request.user.last_name,
            'public_key': account.public_key,
        })
