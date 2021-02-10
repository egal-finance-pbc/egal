from rest_framework import status
from rest_framework.exceptions import ParseError, APIException
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
            return Response(data={
                'id': account.id,
                'public_key': account.public_key,
                'username': account.user.username,
                'first_name': account.user.first_name,
                'last_name': account.user.last_name,
            }, status=status.HTTP_201_CREATED)

        except LedgerError as e:
            raise APIException(detail=e.message, code=status.HTTP_500_INTERNAL_SERVER_ERROR)
